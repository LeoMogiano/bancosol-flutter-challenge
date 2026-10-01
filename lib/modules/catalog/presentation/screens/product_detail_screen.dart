import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/core/i18n/failure_i18n.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/app_fonts.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/product_detail/product_detail_cubit.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/share_product.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/delete_confirm_sheet.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/price_edit_sheet.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_avatar.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/stock_indicator.dart';
import 'package:warehouse/shared/formatters/price_formatter.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/buttons/app_icon_button.dart';
import 'package:warehouse/shared/widgets/cards/app_card.dart';
import 'package:warehouse/shared/widgets/feedback/app_toast.dart';
import 'package:warehouse/shared/widgets/layout/app_top_bar.dart';
import 'package:warehouse/shared/widgets/layout/custom_scaffold.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({required this.remoteId, super.key});

  final String remoteId;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ValueNotifier<bool> _edited = ValueNotifier(false);
  bool _closing = false;

  // Al eliminarse el producto el selector devuelve null: se cierra una sola vez, fuera del build.
  void _closeOnce() {
    if (_closing) return;
    _closing = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _edited.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = context.select<ProductsBloc, Product?>(
      (bloc) => bloc.state.all.where((p) => p.remoteId == widget.remoteId).firstOrNull,
    );
    if (product == null) {
      _closeOnce();
      return const SizedBox.shrink();
    }

    return BlocProvider(
      create: (_) => ProductDetailCubit(shareProduct: sl<ShareProduct>()),
      child: _ProductDetailContent(product: product, edited: _edited, onPriceEdited: () => _edited.value = true),
    );
  }
}

class _ProductDetailContent extends StatelessWidget {
  const _ProductDetailContent({required this.product, required this.edited, required this.onPriceEdited});

  final Product product;
  final ValueNotifier<bool> edited;
  final VoidCallback onPriceEdited;

  Future<void> _openPriceEdit(BuildContext context) async {
    final t = context.t;
    final updated = await PriceEditSheet.open(context, product);
    if (updated != null && context.mounted) {
      context.read<ProductsBloc>().add(ProductUpserted(updated));
      AppToast.show(context, t.toasts.priceUpdated);
      onPriceEdited();
    }
  }

  Future<void> _openDelete(BuildContext context) async {
    final t = context.t;
    final deleted = await DeleteConfirmSheet.open(context, product);
    if (deleted && context.mounted) {
      AppToast.show(context, t.toasts.deleted, icon: Icons.delete_rounded);
      context.read<ProductsBloc>().add(ProductRemoved(product.remoteId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;

    return CustomScaffold(
      padding: EdgeInsets.zero,
      bottomBar: BlocListener<ProductDetailCubit, ProductDetailState>(
        listenWhen: (prev, curr) =>
            prev.confirmedShares != curr.confirmedShares || (curr.shareError != null && prev.shareError == null),
        listener: (context, state) {
          final error = state.shareError;
          error == null
              ? AppToast.show(context, t.toasts.shared, icon: Icons.ios_share_rounded)
              : AppToast.show(context, error.message, icon: Icons.error_rounded);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: colors.line)),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    flex: 10,
                    child: BlocSelector<ProductDetailCubit, ProductDetailState, bool>(
                      selector: (state) => state.sharing,
                      builder: (context, sharing) => AppButton(
                        label: t.detail.share,
                        variant: AppButtonVariant.outline,
                        icon: Icons.ios_share_rounded,
                        loading: sharing,
                        onPressed: () => context.read<ProductDetailCubit>().share(
                          product,
                          text: t.share.text(
                            name: product.name,
                            price: PriceFormatter.format(product.price),
                            currency: product.currency,
                            sku: product.sku,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 13,
                    child: AppButton(
                      label: t.detail.editPrice,
                      icon: Icons.edit_outlined,
                      onPressed: () => _openPriceEdit(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopBar.compact(
              title: t.detail.title,
              onBack: () => Navigator.of(context).pop(),
              action: AppIconButton(
                icon: Icons.delete_outline_rounded,
                color: colors.bad,
                tooltip: t.delete.confirm,
                onPressed: () => _openDelete(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Row(
                    spacing: 16,
                    children: [
                      ProductAvatar(product: product, size: 76),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 21.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: AppFont.playfairDisplay.family,
                                color: colors.ink,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(color: colors.surface2, borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                product.sku,
                                style: TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.w500, color: colors.ink2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppCard(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 6,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              child: Text(
                                t.detail.price,
                                style: TextStyle(fontSize: 14.sp, color: colors.ink2),
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: edited,
                              builder: (_, editedValue, _) {
                                if (!editedValue) return const SizedBox.shrink();
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: colors.accentSoft,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    t.detail.updated,
                                    style: TextStyle(
                                      fontSize: 12.5.sp,
                                      color: colors.accent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          spacing: 6,
                          children: [
                            Flexible(
                              child: Text(
                                PriceFormatter.format(product.price),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 30.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.accent,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            Text(
                              product.currency,
                              style: TextStyle(fontSize: 13.5.sp, fontWeight: FontWeight.w600, color: colors.ink2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _InfoTable(product: product),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(Icons.info_outline_rounded, size: 16, color: colors.ink3),
                        ),
                        Expanded(
                          child: Text(
                            t.detail.note,
                            style: TextStyle(fontSize: 13.5.sp, color: colors.ink3, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTable extends StatelessWidget {
  const _InfoTable({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = context.t;
    final divider = Divider(height: 1, color: colors.line);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _InfoRow(label: t.detail.sku, value: product.sku),
          divider,
          _InfoRow(
            label: t.detail.stock,
            value: '',
            trailing: StockIndicator(stock: product.stock),
          ),
          divider,
          _InfoRow(label: t.detail.currency, value: product.currency),
          divider,
          _InfoRow(label: t.detail.id, value: '${product.id}', valueWeight: FontWeight.w400),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.trailing, this.valueWeight = FontWeight.w600});

  final String label;
  final String value;
  final Widget? trailing;
  final FontWeight valueWeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontSize: 14.5.sp, color: colors.ink2),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 14.5.sp, fontWeight: valueWeight, color: colors.ink),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}
