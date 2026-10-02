import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/inventory_card.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_form_sheet.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/cards/stat_tile.dart';
import 'package:warehouse/shared/widgets/feedback/app_shimmer.dart';
import 'package:warehouse/shared/widgets/feedback/app_state_view.dart';
import 'package:warehouse/shared/widgets/feedback/app_toast.dart';
import 'package:warehouse/shared/widgets/feedback/skeleton_box.dart';

class SummaryBody extends StatelessWidget {
  const SummaryBody({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final view = context.select<ProductsBloc, ProductsView>((bloc) => bloc.state.view);

    return switch (view) {
      ProductsView.loading => const _LoadingState(),
      ProductsView.error => AppStateView(
        type: AppStateType.error,
        title: t.summary.errorTitle,
        message: t.summary.errorMessage,
        actions: [
          AppButton(
            label: t.actions.retry,
            onPressed: () => context.read<ProductsBloc>().add(const ProductsRequested()),
          ),
        ],
      ),
      ProductsView.empty => const _EmptyState(),
      // El resumen ignora la búsqueda: siempre describe el catálogo completo.
      ProductsView.noResults || ProductsView.list => const _SummaryContent(),
    };
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AppStateView(
      type: AppStateType.empty,
      title: t.summary.emptyTitle,
      message: t.summary.emptyMessage,
      actions: [
        AppButton(label: t.actions.newProduct, icon: Icons.add_rounded, onPressed: () => _createProduct(context)),
      ],
    );
  }

  Future<void> _createProduct(BuildContext context) async {
    final t = context.t;
    final bloc = context.read<ProductsBloc>();
    final created = await ProductFormSheet.open(context, existing: bloc.state.all);
    if (created == null || !context.mounted) return;
    bloc.add(ProductUpserted(created));
    AppToast.showSuccess(context, t.toasts.created);
  }
}

class _SummaryContent extends StatelessWidget {
  const _SummaryContent();

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final colors = context.colors;
    final data = context.select<ProductsBloc, ({List<Product> all, DateTime? syncedAt})>(
      (bloc) => (all: bloc.state.all, syncedAt: bloc.state.syncedAt),
    );

    final totalBob = data.all.fold<double>(0, (sum, p) => sum + ProductQuery.priceInBob(p) * p.stock);
    final stats = [
      (label: t.summary.statProducts, value: data.all.length, color: colors.accent),
      (
        label: t.summary.statLowStock,
        value: data.all.where((p) => p.stock > 0 && p.stock <= 5).length,
        color: colors.warn,
      ),
      (label: t.summary.statOutOfStock, value: data.all.where((p) => p.stock == 0).length, color: colors.bad),
    ];

    return Column(
      spacing: 20,
      children: [
        InventoryCard(totalBob: totalBob, syncedAt: data.syncedAt),
        Row(
          spacing: 10,
          children: [
            for (final stat in stats)
              Expanded(
                child: StatTile(
                  label: stat.label,
                  value: '${stat.value}',
                  color: stat.color,
                  onTap: () => StatefulNavigationShell.of(context).goBranch(1),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const AppShimmer(
      child: Column(
        spacing: 20,
        children: [
          SkeletonBox(height: 132, radius: 24),
          Row(
            spacing: 10,
            children: [
              Expanded(child: SkeletonBox(height: 84, radius: 20)),
              Expanded(child: SkeletonBox(height: 84, radius: 20)),
              Expanded(child: SkeletonBox(height: 84, radius: 20)),
            ],
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(child: SkeletonBox(height: 64, radius: 20)),
              Expanded(child: SkeletonBox(height: 64, radius: 20)),
              Expanded(child: SkeletonBox(height: 64, radius: 20)),
            ],
          ),
        ],
      ),
    );
  }
}
