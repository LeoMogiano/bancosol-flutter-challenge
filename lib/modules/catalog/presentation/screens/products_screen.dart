import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/app/router/app_routes.dart';
import 'package:warehouse/core/i18n/failure_i18n.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/application/search_focus/search_focus_cubit.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/filter_sheet.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_form_sheet.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_tile.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/buttons/app_icon_button.dart';
import 'package:warehouse/shared/widgets/feedback/app_shimmer.dart';
import 'package:warehouse/shared/widgets/feedback/app_state_view.dart';
import 'package:warehouse/shared/widgets/feedback/app_toast.dart';
import 'package:warehouse/shared/widgets/feedback/skeleton_box.dart';
import 'package:warehouse/shared/widgets/inputs/search_field.dart';
import 'package:warehouse/shared/widgets/layout/app_top_bar.dart';
import 'package:warehouse/shared/widgets/layout/custom_scaffold.dart';
import 'package:warehouse/shared/widgets/navigation/app_paginator.dart';

enum _ListView { loading, error, empty, noResults, list }

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _searchFocus = FocusNode();
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _refreshStartedHere = false;

  @override
  void initState() {
    super.initState();
    if (context.read<SearchFocusCubit>().state) WidgetsBinding.instance.addPostFrameCallback((_) => _focusSearch());
  }

  void _focusSearch() {
    if (!mounted) return;
    context.read<SearchFocusCubit>().consumed();
    _searchFocus.requestFocus();
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // No espera la respuesta: el skeleton ya indica la carga y el spinner se oculta enseguida.
  Future<void> _refresh() async {
    _refreshStartedHere = true;
    context.read<ProductsBloc>().add(const ProductsRefreshed());
  }

  void _clearSearchAndFilters() {
    _searchController.clear();
    context.read<ProductsBloc>()
      ..add(const ProductsQueryChanged(''))
      ..add(const ProductsFiltersApplied(ProductFilters.none));
  }

  Future<void> _openFilters() async {
    final bloc = context.read<ProductsBloc>();
    final result = await FilterSheet.open(context, state: bloc.state);
    if (result == null) return;
    bloc
      ..add(ProductsSortChanged(result.sort))
      ..add(ProductsFiltersApplied(result.filters));
  }

  Future<void> _openProductForm(BuildContext context) async {
    final t = context.t;
    final bloc = context.read<ProductsBloc>();
    final created = await ProductFormSheet.open(context, existing: bloc.state.all);
    if (created != null && context.mounted) {
      bloc.add(ProductUpserted(created));
      _searchController.clear();
      bloc
        ..add(const ProductsQueryChanged(''))
        ..add(const ProductsFiltersApplied(ProductFilters.none));
      AppToast.show(context, t.toasts.created);
    }
  }

  void _goToPage(int page) {
    context.read<ProductsBloc>().add(ProductsPageChanged(page));
    if (_scrollController.hasClients) _scrollController.animateTo(0, duration: _scrollDuration, curve: Curves.easeOut);
  }

  static const _scrollDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return MultiBlocListener(
      listeners: [
        BlocListener<ProductsBloc, ProductsState>(
          listenWhen: (prev, curr) => _refreshStartedHere && prev.isRefreshing && !curr.isRefreshing,
          listener: (context, state) {
            _refreshStartedHere = false;
            final failure = state.failure;
            failure == null
                ? AppToast.show(context, t.toasts.listUpdated)
                : AppToast.show(context, failure.message, icon: Icons.error_rounded);
          },
        ),
        BlocListener<SearchFocusCubit, bool>(listenWhen: (_, pending) => pending, listener: (_, _) => _focusSearch()),
      ],
      child: CustomScaffold(
        scrollable: true,
        onRefresh: _refresh,
        scrollController: _scrollController,
        padding: EdgeInsets.zero,
        body: Column(
          children: [
            AppTopBar.large(
              eyebrow: t.products.eyebrow,
              title: t.products.title,
              actions: [
                AppButton(
                  label: t.products.newShort,
                  compact: true,
                  icon: Icons.add_rounded,
                  onPressed: () => _openProductForm(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: SearchField(
                controller: _searchController,
                focusNode: _searchFocus,
                hintText: t.products.searchHint,
                onChanged: (query) => context.read<ProductsBloc>().add(ProductsQueryChanged(query)),
                trailing: BlocSelector<ProductsBloc, ProductsState, int>(
                  selector: (state) => state.filters.activeCount,
                  builder: (_, activeCount) => AppIconButton(
                    icon: Icons.tune_rounded,
                    background: context.colors.surface2,
                    size: 40,
                    badge: activeCount,
                    tooltip: t.filters.title,
                    onPressed: _openFilters,
                  ),
                ),
              ),
            ),
            _ResultsLine(onClearFilters: _clearSearchAndFilters),
            BlocSelector<ProductsBloc, ProductsState, _ListView>(
              selector: _viewFor,
              builder: (context, view) => switch (view) {
                _ListView.loading => const _LoadingList(),
                _ListView.error => AppStateView(
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
                _ListView.empty => AppStateView(
                  type: AppStateType.empty,
                  title: t.products.emptyTitle,
                  message: t.products.emptyMessage,
                ),
                _ListView.noResults => BlocSelector<ProductsBloc, ProductsState, String>(
                  selector: (state) => state.query,
                  builder: (_, query) => AppStateView(
                    type: AppStateType.noResults,
                    title: query.isEmpty ? t.products.noResultsNoQuery : t.products.noResultsTitle(query: query),
                    message: t.products.noResultsMessage,
                    actions: [
                      AppButton(
                        label: t.products.clearSearch,
                        variant: AppButtonVariant.outline,
                        onPressed: _clearSearchAndFilters,
                      ),
                    ],
                  ),
                ),
                _ListView.list => _ProductList(onPageChanged: _goToPage),
              },
            ),
          ],
        ),
      ),
    );
  }

  static _ListView _viewFor(ProductsState state) {
    if (state.isRefreshing || state.status == ProductsStatus.loading || state.status == ProductsStatus.initial) {
      return _ListView.loading;
    }
    if (state.status == ProductsStatus.failure) return _ListView.error;
    if (state.all.isEmpty) return _ListView.empty;
    if (state.visible.isEmpty) return _ListView.noResults;
    return _ListView.list;
  }
}

class _ResultsLine extends StatelessWidget {
  const _ResultsLine({required this.onClearFilters});

  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final data = context.select<ProductsBloc, ({int count, bool filtered})>(
      (bloc) => (count: bloc.state.visible.length, filtered: bloc.state.filters.activeCount > 0),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 8, 12, 4),
      child: SizedBox(
        height: 36,
        child: Row(
          children: [
            Expanded(
              child: Text(
                t.products.results(n: data.count),
                style: TextStyle(fontSize: 14.sp, color: context.colors.ink2),
              ),
            ),
            if (data.filtered)
              TextButton(
                onPressed: onClearFilters,
                child: Text(
                  t.products.clearFilters,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: context.colors.accent),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.onPageChanged});

  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    // Se seleccionan `visible` y `page` (mismas instancias entre emisiones), no `pageItems`, que es una lista
    // nueva en cada acceso y reconstruiría la lista entera con cualquier cambio de estado.
    // Se seleccionan `visible` y `page` (mismas instancias entre emisiones), no `pageItems`, que es una lista
    // nueva en cada acceso y reconstruiría la lista entera con cualquier cambio de estado.
    final data = context.select<ProductsBloc, ({List<Product> visible, int page, String? highlightId, bool offline})>(
      (bloc) => (
        visible: bloc.state.visible,
        page: bloc.state.page,
        highlightId: bloc.state.highlightId,
        offline: bloc.state.isOffline,
      ),
    );
    final items = ProductQuery.page(data.visible, data.page);
    return Padding(
      // Holgura para que la barra de navegación flotante (y el aviso offline) no tapen el último elemento.
      padding: EdgeInsets.fromLTRB(20, 4, 20, data.offline ? 190 : 130),
      child: Column(
        spacing: 8,
        children: [
          for (final product in items)
            ProductTile(
              product: product,
              highlighted: product.remoteId == data.highlightId,
              onTap: () => context.push(AppRoutes.productDetail(product.remoteId)),
            ),
          _PaginationFooter(onPageChanged: onPageChanged),
        ],
      ),
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({required this.onPageChanged});

  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final data = context.select<ProductsBloc, ({int page, int pageCount, int shown, int total})>(
      (bloc) => (
        page: bloc.state.page,
        pageCount: bloc.state.pageCount,
        shown: bloc.state.pageItems.length,
        total: bloc.state.visible.length,
      ),
    );
    final from = (data.page - 1) * ProductQuery.pageSize + 1;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        spacing: 12,
        children: [
          Text(
            t.products.showing(from: '$from', to: '${from + data.shown - 1}', total: '${data.total}'),
            style: TextStyle(fontSize: 13.sp, color: context.colors.ink3),
          ),
          AppPaginator(page: data.page, pageCount: data.pageCount, onChanged: onPageChanged),
        ],
      ),
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
