import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:warehouse/core/i18n/failure_i18n.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/core/theme/theme_context.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';
import 'package:warehouse/modules/catalog/presentation/shell/main_shell.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/filter_sheet.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_tile.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/buttons/app_icon_button.dart';
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
  SearchFocusRequest? _focusRequest;
  bool _refreshStartedHere = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Se captura aquí: en dispose() el context ya no puede leer providers.
    if (_focusRequest == null) {
      _focusRequest = context.read<SearchFocusRequest>()..changes.addListener(_onFocusRequested);
      if (_focusRequest!.consume()) WidgetsBinding.instance.addPostFrameCallback((_) => _searchFocus.requestFocus());
    }
  }

  void _onFocusRequested() {
    if (_focusRequest!.consume()) _searchFocus.requestFocus();
  }

  @override
  void dispose() {
    _focusRequest?.changes.removeListener(_onFocusRequested);
    _searchFocus.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    _refreshStartedHere = true;
    final bloc = context.read<ProductsBloc>()..add(const ProductsRefreshed());
    await bloc.stream.firstWhere((state) => !state.isRefreshing);
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

  void _goToPage(int page) {
    context.read<ProductsBloc>().add(ProductsPageChanged(page));
    if (_scrollController.hasClients) _scrollController.animateTo(0, duration: _scrollDuration, curve: Curves.easeOut);
  }

  static const _scrollDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return BlocListener<ProductsBloc, ProductsState>(
      listenWhen: (prev, curr) => _refreshStartedHere && prev.isRefreshing && !curr.isRefreshing,
      listener: (context, state) {
        _refreshStartedHere = false;
        final failure = state.failure;
        failure == null
            ? AppToast.show(context, t.toasts.listUpdated)
            : AppToast.show(context, failure.message, icon: Icons.error_rounded);
      },
      child: CustomScaffold(
        padding: EdgeInsets.zero,
        body: Column(
          children: [
            AppTopBar.large(
              eyebrow: t.products.eyebrow,
              title: t.products.title,
              actions: [AppButton(label: t.products.newShort, compact: true, icon: Icons.add_rounded, onPressed: null)],
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
                    badge: activeCount,
                    tooltip: t.filters.title,
                    onPressed: _openFilters,
                  ),
                ),
              ),
            ),
            _ResultsLine(onClearFilters: _clearSearchAndFilters),
            Expanded(
              child: BlocSelector<ProductsBloc, ProductsState, _ListView>(
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
                    actions: [
                      AppButton(label: t.actions.refresh, variant: AppButtonVariant.outline, onPressed: _refresh),
                    ],
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
                  _ListView.list => RefreshIndicator(
                    color: context.colors.accent,
                    onRefresh: _refresh,
                    child: _ProductList(controller: _scrollController, onPageChanged: _goToPage),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static _ListView _viewFor(ProductsState state) {
    if (state.status == ProductsStatus.loading || state.status == ProductsStatus.initial) return _ListView.loading;
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
    return BlocSelector<ProductsBloc, ProductsState, ({int count, bool filtered})>(
      selector: (state) => (count: state.visible.length, filtered: state.filters.activeCount > 0),
      builder: (context, data) => Padding(
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
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.controller, required this.onPageChanged});

  final ScrollController controller;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    // Se seleccionan `visible` y `page` (mismas instancias entre emisiones), no `pageItems`, que es una lista
    // nueva en cada acceso y reconstruiría la lista entera con cualquier cambio de estado.
    return BlocSelector<ProductsBloc, ProductsState, ({List<Product> visible, int page, String? highlightId})>(
      selector: (state) => (visible: state.visible, page: state.page, highlightId: state.highlightId),
      builder: (context, data) {
        final items = ProductQuery.page(data.visible, data.page);
        return ListView.separated(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          // 130: holgura para que la barra de navegación flotante no tape el último elemento.
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 130),
          itemCount: items.length + 1,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            if (index == items.length) return _PaginationFooter(onPageChanged: onPageChanged);
            final product = items[index];
            return ProductTile(product: product, highlighted: product.remoteId == data.highlightId, onTap: () {});
          },
        );
      },
    );
  }
}

class _PaginationFooter extends StatelessWidget {
  const _PaginationFooter({required this.onPageChanged});

  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return BlocSelector<ProductsBloc, ProductsState, ({int page, int pageCount, int shown, int total})>(
      selector: (state) =>
          (page: state.page, pageCount: state.pageCount, shown: state.pageItems.length, total: state.visible.length),
      builder: (context, data) {
        final from = (data.page - 1) * ProductQuery.pageSize + 1;
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            children: [
              Text(
                t.products.showing(from: '$from', to: '${from + data.shown - 1}', total: '${data.total}'),
                style: TextStyle(fontSize: 13.sp, color: context.colors.ink3),
              ),
              const SizedBox(height: 12),
              AppPaginator(page: data.page, pageCount: data.pageCount, onChanged: onPageChanged),
            ],
          ),
        );
      },
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, _) => const SkeletonBox(height: 72),
    );
  }
}
