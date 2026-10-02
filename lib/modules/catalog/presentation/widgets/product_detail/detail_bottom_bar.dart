import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/i18n/failure_i18n.dart';
import 'package:warehouse/core/i18n/generated/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/product_detail/product_detail_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/shared/formatters/price_formatter.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/feedback/app_toast.dart';

class DetailBottomBar extends StatelessWidget {
  const DetailBottomBar({required this.product, required this.onEditPrice, super.key});

  final Product product;
  final VoidCallback onEditPrice;

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return BlocListener<ProductDetailBloc, ProductDetailState>(
      listenWhen: (prev, curr) =>
          prev.confirmedShares != curr.confirmedShares || (curr.shareError != null && prev.shareError == null),
      listener: (context, state) {
        final error = state.shareError;
        if (error == null) {
          AppToast.showSuccess(context, t.toasts.shared, icon: Icons.ios_share_rounded);
        } else {
          AppToast.showError(context, error.message);
        }
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: context.colors.line)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Row(
              spacing: 10,
              children: [
                Expanded(flex: 10, child: _ShareButton(product: product)),
                Expanded(
                  flex: 13,
                  child: AppButton(label: t.detail.editPrice, icon: Icons.edit_outlined, onPressed: onEditPrice),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final sharing = context.select<ProductDetailBloc, bool>((bloc) => bloc.state.sharing);

    return AppButton(
      label: t.detail.share,
      variant: AppButtonVariant.outline,
      icon: Icons.ios_share_rounded,
      loading: sharing,
      onPressed: () => context.read<ProductDetailBloc>().add(
        ProductDetailShareRequested(
          product,
          text: t.share.text(
            name: product.name,
            price: PriceFormatter.format(product.price),
            currency: product.currency.code,
            sku: product.sku,
          ),
        ),
      ),
    );
  }
}
