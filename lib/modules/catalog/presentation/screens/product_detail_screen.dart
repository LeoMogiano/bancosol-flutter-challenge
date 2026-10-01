import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/di/service_locator.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/product_detail/product_detail_cubit.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/share_product.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/delete_confirm_sheet.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/price_edit_sheet.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_detail/detail_bottom_bar.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_detail/detail_header.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_detail/detail_info_table.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_detail/detail_price_card.dart';
import 'package:warehouse/shared/widgets/buttons/app_icon_button.dart';
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

    return CustomScaffold(
      padding: EdgeInsets.zero,
      bottomBar: DetailBottomBar(product: product, onEditPrice: () => _openPriceEdit(context)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTopBar.compact(
              title: t.detail.title,
              onBack: () => Navigator.of(context).pop(),
              action: AppIconButton(
                icon: Icons.delete_outline_rounded,
                color: context.colors.bad,
                tooltip: t.delete.confirm,
                onPressed: () => _openDelete(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  DetailHeader(product: product),
                  DetailPriceCard(price: product.price, currency: product.currency, edited: edited),
                  DetailInfoTable(product: product),
                  const _DetailNote(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailNote extends StatelessWidget {
  const _DetailNote();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;

    return Padding(
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
    );
  }
}
