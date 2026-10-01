import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/i18n/failure_i18n.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/price_edit/price_edit_cubit.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/update_product_price.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';
import 'package:warehouse/shared/formatters/price_formatter.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/feedback/app_toast.dart';
import 'package:warehouse/shared/widgets/feedback/custom_bottom_sheet.dart';
import 'package:warehouse/shared/widgets/feedback/error_banner.dart';
import 'package:warehouse/shared/widgets/inputs/price_field.dart';

class PriceEditSheet extends StatelessWidget {
  const PriceEditSheet({required this.product, super.key});

  final Product product;

  static Future<Product?> open(BuildContext context, Product product) =>
      CustomBottomSheet.show<Product>(context, PriceEditSheet(product: product));

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PriceEditCubit(product: product, updatePrice: sl<UpdateProductPrice>()),
      child: PriceEditContent(product: product),
    );
  }
}

@visibleForTesting
class PriceEditContent extends StatelessWidget {
  const PriceEditContent({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    return MultiBlocListener(
      listeners: [
        BlocListener<PriceEditCubit, PriceEditState>(
          listenWhen: (prev, curr) => prev.saved == null && curr.saved != null,
          listener: (context, state) => Navigator.of(context).pop(state.saved),
        ),
        // 404: el producto ya no existe; editarlo no tiene sentido, se cierra y se recarga la lista.
        BlocListener<PriceEditCubit, PriceEditState>(
          listenWhen: (prev, curr) => curr.submitError?.type == FailureType.notFound && prev.submitError == null,
          listener: (context, state) {
            final products = context.read<ProductsBloc>();
            AppToast.show(context, state.submitError!.message, icon: Icons.error_rounded);
            Navigator.of(context).pop();
            products.add(const ProductsRefreshed());
          },
        ),
      ],
      child: BlocSelector<PriceEditCubit, PriceEditState, bool>(
        selector: (state) => state.submitting,
        // Mientras guarda no se puede cerrar: el usuario no sabría si el precio cambió.
        builder: (context, submitting) => PopScope(
          canPop: !submitting,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SheetHeader(title: t.priceEdit.title, subtitle: '${product.name} · ${product.sku}'),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t.priceEdit.currentPrice,
                      style: TextStyle(fontSize: 14.sp, color: colors.ink2),
                    ),
                  ),
                  Text(
                    '${PriceFormatter.format(product.price)} ${product.currency}',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: colors.ink),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const _PriceInput(),
              const _ServerError(),
              const SizedBox(height: 18),
              const _Actions(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceInput extends StatelessWidget {
  const _PriceInput();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cubit = context.read<PriceEditCubit>();
    final data = context.select<PriceEditCubit, ({PriceError? error, int? changePercent})>(
      (bloc) => (error: bloc.error, changePercent: bloc.changePercent),
    );
    final error = switch (data.error) {
      PriceError.incompleteDecimals => t.validation.priceIncomplete,
      PriceError.notPositive => t.validation.priceNotPositive,
      PriceError.tooHigh => t.validation.priceTooHigh,
      PriceError.currencyEmpty => t.validation.currencyEmpty,
      PriceError.empty || PriceError.unchanged || null => null,
    };
    final helper = switch (data.error) {
      PriceError.empty => t.validation.priceEmpty,
      PriceError.unchanged => t.validation.priceUnchanged,
      _ when data.changePercent != null => t.priceEdit.bigChange(percent: data.changePercent!),
      _ => t.priceEdit.help,
    };
    return PriceField(
      currency: cubit.state.product.currency,
      large: true,
      autofocus: true,
      initialValue: cubit.state.draft,
      onChanged: cubit.draftChanged,
      errorText: error,
      helperText: helper,
      helperIsWarning: data.error == null && data.changePercent != null,
    );
  }
}

class _ServerError extends StatelessWidget {
  const _ServerError();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final failure = context.select<PriceEditCubit, Failure?>((bloc) => bloc.state.submitError);
    if (failure == null) return const SizedBox.shrink();
    final message = switch (failure.type) {
      FailureType.network || FailureType.timeout => t.priceEdit.offlineError,
      FailureType.notFound => failure.message,
      _ => t.priceEdit.serverError,
    };
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: ErrorBanner(title: t.priceEdit.errorTitle, message: message),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cubit = context.read<PriceEditCubit>();
    final data = context.select<PriceEditCubit, ({bool canSubmit, bool submitting, bool failed})>(
      (bloc) => (canSubmit: bloc.canSubmit, submitting: bloc.state.submitting, failed: bloc.state.submitError != null),
    );
    return SheetActions(
      secondary: AppButton(
        label: t.actions.cancel,
        variant: AppButtonVariant.outline,
        onPressed: data.submitting ? null : () => Navigator.of(context).maybePop(),
      ),
      primary: AppButton(
        label: data.failed ? t.actions.retry : t.priceEdit.save,
        loading: data.submitting,
        loadingLabel: t.priceEdit.saving,
        onPressed: data.canSubmit ? cubit.submit : null,
      ),
    );
  }
}
