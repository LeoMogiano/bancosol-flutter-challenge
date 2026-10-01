import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/i18n/failure_i18n.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/services/haptic_service.dart';
import 'package:warehouse/core/theme/app_fonts.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/delete_product/delete_product_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/feedback/custom_bottom_sheet.dart';
import 'package:warehouse/shared/widgets/feedback/error_banner.dart';

class DeleteConfirmSheet extends StatelessWidget {
  const DeleteConfirmSheet({required this.product, super.key});

  static const double _iconCircle = 76;

  final Product product;

  static Future<bool> open(BuildContext context, Product product) async =>
      await CustomBottomSheet.show<bool>(context, DeleteConfirmSheet(product: product)) ?? false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DeleteProductBloc>(param1: product),
      child: BlocListener<DeleteProductBloc, DeleteProductState>(
        listenWhen: (prev, curr) => prev.submitting && !curr.submitting,
        listener: (context, state) => state.deleted ? Navigator.of(context).pop(true) : HapticService.error(),
        child: BlocBuilder<DeleteProductBloc, DeleteProductState>(
          builder: (context, state) => PopScope(canPop: !state.submitting, child: _content(context, state)),
        ),
      ),
    );
  }

  Widget _content(BuildContext context, DeleteProductState state) {
    final t = context.t;
    final colors = context.colors;
    final failure = state.submitError;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: _iconCircle,
          height: _iconCircle,
          decoration: BoxDecoration(color: colors.badSoft, shape: BoxShape.circle),
          child: Icon(Icons.delete_rounded, size: 34, color: colors.bad),
        ),
        const SizedBox(height: 18),
        Text(
          t.delete.title,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: AppFont.playfairDisplay.family, fontSize: 19.65.sp, color: colors.ink),
        ),
        const SizedBox(height: 10),
        Text(
          t.delete.message(name: product.name, sku: product.sku),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.5.sp, height: 1.5, color: colors.ink2),
        ),
        if (failure != null) ...[const SizedBox(height: 16), ErrorBanner(message: _errorMessage(t, failure))],
        const SizedBox(height: 22),
        SheetActions(
          secondary: AppButton(
            label: t.actions.cancel,
            variant: AppButtonVariant.outline,
            onPressed: state.submitting ? null : () => Navigator.of(context).maybePop(),
          ),
          primary: AppButton(
            label: failure != null ? t.actions.retry : t.delete.confirm,
            variant: AppButtonVariant.danger,
            loading: state.submitting,
            loadingLabel: t.delete.deleting,
            onPressed: () => context.read<DeleteProductBloc>().add(const DeleteProductConfirmed()),
          ),
        ),
      ],
    );
  }

  static String _errorMessage(Translations t, Failure failure) => switch (failure.type) {
    FailureType.network || FailureType.timeout => t.delete.offlineError,
    FailureType.notFound => failure.message,
    _ => t.delete.serverError,
  };
}
