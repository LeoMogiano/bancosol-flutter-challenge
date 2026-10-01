import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/product_form/product_form_cubit.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/create_product.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';
import 'package:warehouse/modules/catalog/domain/validators/product_form_validator.dart';
import 'package:warehouse/shared/formatters/name_input_formatter.dart';
import 'package:warehouse/shared/formatters/sku_input_formatter.dart';
import 'package:warehouse/shared/formatters/stock_input_formatter.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/feedback/custom_bottom_sheet.dart';
import 'package:warehouse/shared/widgets/feedback/error_banner.dart';
import 'package:warehouse/shared/widgets/inputs/app_segmented.dart';
import 'package:warehouse/shared/widgets/inputs/custom_input.dart';
import 'package:warehouse/shared/widgets/inputs/price_field.dart';

class ProductFormSheet extends StatelessWidget {
  const ProductFormSheet({required this.existing, super.key});

  final List<Product> existing;

  static Future<Product?> open(BuildContext context, {required List<Product> existing}) {
    return CustomBottomSheet.show<Product>(context, ProductFormSheet(existing: existing));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductFormCubit(existing: existing, createProduct: sl<CreateProduct>()),
      child: BlocListener<ProductFormCubit, ProductFormState>(
        listenWhen: (prev, curr) => prev.created == null && curr.created != null,
        listener: (context, state) => Navigator.of(context).pop(state.created),
        child: const _ProductFormContent(),
      ),
    );
  }
}

class _ProductFormContent extends StatelessWidget {
  const _ProductFormContent();

  static const double _sideBySideMinWidth = 340;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return BlocSelector<ProductFormCubit, ProductFormState, bool>(
      selector: (state) => state.submitting,
      builder: (context, submitting) {
        return PopScope(
          canPop: !submitting,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SheetHeader(title: t.form.title),
              const SizedBox(height: 18),
              const _SkuField(),
              const SizedBox(height: 12),
              const _NameField(),
              const SizedBox(height: 12),
              // Lado a lado no deja espacio para el monto en pantallas de 320–360 dp.
              LayoutBuilder(
                builder: (_, constraints) => constraints.maxWidth < _sideBySideMinWidth
                    ? const Column(children: [_PriceField(), SizedBox(height: 12), _StockField()])
                    : const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 5, child: _PriceField()),
                          SizedBox(width: 10),
                          Expanded(flex: 4, child: _StockField()),
                        ],
                      ),
              ),
              const SizedBox(height: 12),
              const _CurrencyField(),
              const SizedBox(height: 18),
              const _ErrorBanner(),
              const _ActionsSection(),
            ],
          ),
        );
      },
    );
  }
}

class _SkuField extends StatelessWidget {
  const _SkuField();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return BlocSelector<ProductFormCubit, ProductFormState, (String, SkuError?)>(
      selector: (state) => (state.sku, cubit.skuError),
      builder: (context, data) {
        final errorText = data.$2 != null
            ? switch (data.$2) {
                SkuError.empty => context.t.validation.skuEmpty,
                SkuError.tooShort => context.t.validation.skuTooShort,
                SkuError.invalidFormat => context.t.validation.skuFormat,
                SkuError.duplicate => context.t.validation.skuDuplicate,
                null => null,
              }
            : null;

        return CustomInput(
          label: context.t.form.sku,
          initialValue: data.$1,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [SkuInputFormatter()],
          onChanged: cubit.skuChanged,
          onBlur: () => cubit.fieldBlurred(ProductField.sku),
          errorText: errorText,
        );
      },
    );
  }
}

class _NameField extends StatelessWidget {
  const _NameField();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return BlocSelector<ProductFormCubit, ProductFormState, (String, NameError?)>(
      selector: (state) => (state.name, cubit.nameError),
      builder: (context, data) {
        final errorText = data.$2 != null
            ? switch (data.$2) {
                NameError.empty => context.t.validation.nameEmpty,
                NameError.tooShort => context.t.validation.nameTooShort,
                NameError.onlyDigits => context.t.validation.nameOnlyDigits,
                NameError.duplicate => context.t.validation.nameDuplicate,
                null => null,
              }
            : null;

        return CustomInput(
          label: context.t.form.name,
          initialValue: data.$1,
          inputFormatters: [NameInputFormatter()],
          onChanged: cubit.nameChanged,
          onBlur: () => cubit.fieldBlurred(ProductField.name),
          errorText: errorText,
        );
      },
    );
  }
}

class _PriceField extends StatelessWidget {
  const _PriceField();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return BlocSelector<ProductFormCubit, ProductFormState, (String, String, PriceError?)>(
      selector: (state) => (state.price, state.currency, cubit.priceError),
      builder: (context, data) {
        final errorText = data.$3 != null
            ? switch (data.$3) {
                PriceError.empty => context.t.validation.priceEmpty,
                PriceError.incompleteDecimals => context.t.validation.priceIncomplete,
                PriceError.notPositive => context.t.validation.priceNotPositive,
                PriceError.tooHigh => context.t.validation.priceTooHigh,
                PriceError.currencyEmpty => context.t.validation.currencyEmpty,
                PriceError.unchanged => null,
                null => null,
              }
            : null;

        return PriceField(
          label: context.t.form.price,
          currency: data.$2,
          initialValue: data.$1,
          onChanged: cubit.priceChanged,
          onBlur: () => cubit.fieldBlurred(ProductField.price),
          errorText: errorText,
        );
      },
    );
  }
}

class _StockField extends StatelessWidget {
  const _StockField();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return BlocSelector<ProductFormCubit, ProductFormState, (String, StockError?)>(
      selector: (state) => (state.stock, cubit.stockError),
      builder: (context, data) {
        final errorText = data.$2 != null
            ? switch (data.$2) {
                StockError.empty => context.t.validation.stockEmpty,
                StockError.tooHigh => context.t.validation.stockTooHigh,
                null => null,
              }
            : null;

        return CustomInput(
          label: context.t.form.stock,
          initialValue: data.$1,
          keyboardType: TextInputType.number,
          inputFormatters: [StockInputFormatter()],
          onChanged: cubit.stockChanged,
          onBlur: () => cubit.fieldBlurred(ProductField.stock),
          errorText: errorText,
        );
      },
    );
  }
}

class _CurrencyField extends StatelessWidget {
  const _CurrencyField();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.form.currency,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: context.colors.ink2),
        ),
        const SizedBox(height: 8),
        BlocSelector<ProductFormCubit, ProductFormState, String>(
          selector: (state) => state.currency,
          builder: (context, currency) {
            return AppSegmented<String>(
              segments: const [
                AppSegment(value: 'BOB', label: 'BOB'),
                AppSegment(value: 'USD', label: 'USD'),
              ],
              selected: currency,
              onChanged: cubit.currencyChanged,
            );
          },
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProductFormCubit, ProductFormState, bool>(
      selector: (state) => state.submitError != null,
      builder: (context, hasError) {
        if (!hasError) return const SizedBox.shrink();
        final failure = context.read<ProductFormCubit>().state.submitError!;
        final message = switch (failure.type) {
          FailureType.network || FailureType.timeout => context.t.form.offlineError,
          _ => context.t.form.serverError,
        };
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: ErrorBanner(message: message),
        );
      },
    );
  }
}

class _ActionsSection extends StatelessWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();

    return BlocSelector<ProductFormCubit, ProductFormState, ({bool submitting, bool hasError})>(
      selector: (state) => (submitting: state.submitting, hasError: state.submitError != null),
      builder: (context, data) {
        return SheetActions(
          secondary: AppButton(
            label: context.t.actions.cancel,
            variant: AppButtonVariant.outline,
            onPressed: data.submitting ? null : () => Navigator.of(context).maybePop(),
          ),
          primary: AppButton(
            label: data.hasError ? context.t.actions.retry : context.t.form.create,
            loading: data.submitting,
            loadingLabel: context.t.form.creating,
            onPressed: data.submitting ? null : cubit.submit,
          ),
        );
      },
    );
  }
}
