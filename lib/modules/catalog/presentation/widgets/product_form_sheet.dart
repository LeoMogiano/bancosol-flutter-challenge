import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/services/haptic_service.dart';
import 'package:warehouse/modules/catalog/application/product_form/product_form_cubit.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/create_product.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_form/product_form_fields.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/feedback/custom_bottom_sheet.dart';
import 'package:warehouse/shared/widgets/feedback/error_banner.dart';

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
        listenWhen: (prev, curr) => prev.submitting && !curr.submitting,
        listener: (context, state) =>
            state.created != null ? Navigator.of(context).pop(state.created) : HapticService.error(),
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

    final submitting = context.select<ProductFormCubit, bool>((bloc) => bloc.state.submitting);
    return PopScope(
      canPop: !submitting,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SheetHeader(title: t.form.title),
          const SizedBox(height: 18),
          const FormSkuField(),
          const SizedBox(height: 12),
          const FormNameField(),
          const SizedBox(height: 12),
          // Lado a lado no deja espacio para el monto en pantallas de 320–360 dp.
          LayoutBuilder(
            builder: (_, constraints) => constraints.maxWidth < _sideBySideMinWidth
                ? const Column(spacing: 12, children: [FormPriceField(), FormStockField()])
                : const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Expanded(flex: 5, child: FormPriceField()),
                      Expanded(flex: 4, child: FormStockField()),
                    ],
                  ),
          ),
          const SizedBox(height: 12),
          const FormCurrencyField(),
          const SizedBox(height: 18),
          const _ErrorBanner(),
          const _ActionsSection(),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final failure = context.select<ProductFormCubit, Failure?>((bloc) => bloc.state.submitError);
    if (failure == null) return const SizedBox.shrink();
    final message = switch (failure.type) {
      FailureType.network || FailureType.timeout => t.form.offlineError,
      _ => t.form.serverError,
    };
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: ErrorBanner(message: message),
    );
  }
}

class _ActionsSection extends StatelessWidget {
  const _ActionsSection();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final cubit = context.read<ProductFormCubit>();

    final data = context.select<ProductFormCubit, ({bool submitting, bool hasError})>(
      (bloc) => (submitting: bloc.state.submitting, hasError: bloc.state.submitError != null),
    );
    return SheetActions(
      secondary: AppButton(
        label: t.actions.cancel,
        variant: AppButtonVariant.outline,
        onPressed: data.submitting ? null : () => Navigator.of(context).maybePop(),
      ),
      primary: AppButton(
        label: data.hasError ? t.actions.retry : t.form.create,
        loading: data.submitting,
        loadingLabel: t.form.creating,
        onPressed: data.submitting ? null : cubit.submit,
      ),
    );
  }
}
