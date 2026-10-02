import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/products/product_list.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/feedback/app_shimmer.dart';
import 'package:warehouse/shared/widgets/feedback/app_state_view.dart';
import 'package:warehouse/shared/widgets/feedback/skeleton_box.dart';

class ProductsBody extends StatelessWidget {
  const ProductsBody({required this.onClearSearch, required this.onPageChanged, super.key});

  final VoidCallback onClearSearch;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final view = context.select<ProductsBloc, ProductsView>((bloc) => bloc.state.view);

    return switch (view) {
      ProductsView.loading => const _LoadingList(),
      ProductsView.error => AppStateView(
        type: AppStateType.error,
        title: t.products.errorTitle,
        message: t.products.errorMessage,
        actions: [
          AppButton(
            label: t.actions.retry,
            icon: Icons.refresh_rounded,
            onPressed: () => context.read<ProductsBloc>().add(const ProductsRequested()),
          ),
        ],
      ),
      ProductsView.empty => AppStateView(
        type: AppStateType.empty,
        title: t.products.emptyTitle,
        message: t.products.emptyMessage,
      ),
      ProductsView.noResults => _NoResultsView(onClearSearch: onClearSearch),
      ProductsView.list => ProductList(onPageChanged: onPageChanged),
    };
  }
}

class _NoResultsView extends StatelessWidget {
  const _NoResultsView({required this.onClearSearch});

  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final query = context.select<ProductsBloc, String>((bloc) => bloc.state.query);

    return AppStateView(
      type: AppStateType.noResults,
      title: query.isEmpty ? t.products.noResultsNoQuery : t.products.noResultsTitle(query: query),
      message: t.products.noResultsMessage,
      actions: [AppButton(label: t.products.clearSearch, variant: AppButtonVariant.outline, onPressed: onClearSearch)],
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
        child: Column(spacing: 8, children: [for (var i = 0; i < 6; i++) const SkeletonBox(height: 72)]),
      ),
    );
  }
}
