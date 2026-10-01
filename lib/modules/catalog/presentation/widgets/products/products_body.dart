import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/products/product_list.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/feedback/app_shimmer.dart';
import 'package:warehouse/shared/widgets/feedback/app_state_view.dart';
import 'package:warehouse/shared/widgets/feedback/skeleton_box.dart';

enum _BodyView { loading, error, empty, noResults, list }

class ProductsBody extends StatelessWidget {
  const ProductsBody({required this.onClearSearch, required this.onPageChanged, super.key});

  final VoidCallback onClearSearch;
  final ValueChanged<int> onPageChanged;

  static _BodyView _viewFor(ProductsState state) {
    if (state.isLoading) return _BodyView.loading;
    if (state.status == ProductsStatus.failure) return _BodyView.error;
    if (state.all.isEmpty) return _BodyView.empty;
    if (state.visible.isEmpty) return _BodyView.noResults;
    return _BodyView.list;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final view = context.select<ProductsBloc, _BodyView>((bloc) => _viewFor(bloc.state));

    return switch (view) {
      _BodyView.loading => const _LoadingList(),
      _BodyView.error => AppStateView(
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
      _BodyView.empty => AppStateView(
        type: AppStateType.empty,
        title: t.products.emptyTitle,
        message: t.products.emptyMessage,
      ),
      _BodyView.noResults => _NoResultsView(onClearSearch: onClearSearch),
      _BodyView.list => ProductList(onPageChanged: onPageChanged),
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
