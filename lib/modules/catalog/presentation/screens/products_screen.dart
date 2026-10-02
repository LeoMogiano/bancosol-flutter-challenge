import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/i18n/failure_i18n.dart';
import 'package:warehouse/core/i18n/strings.g.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/application/search_focus/search_focus_cubit.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/filter_sheet.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/product_form_sheet.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/products/products_body.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/products/products_search_bar.dart';
import 'package:warehouse/modules/catalog/presentation/widgets/products/results_line.dart';
import 'package:warehouse/shared/widgets/buttons/app_button.dart';
import 'package:warehouse/shared/widgets/feedback/app_toast.dart';
import 'package:warehouse/shared/widgets/layout/app_top_bar.dart';
import 'package:warehouse/shared/widgets/layout/custom_scaffold.dart';

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
    if (context.read<SearchFocusCubit>().state) _scheduleFocusSearch();
  }

  void _scheduleFocusSearch() => WidgetsBinding.instance.addPostFrameCallback((_) => _focusSearch());

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
      AppToast.showSuccess(context, t.toasts.created);
    }
  }

  void _goToPage(int page) {
    context.read<ProductsBloc>().add(ProductsPageChanged(page));
    // Tras el frame de la página nueva: si es más corta, animar desde la posición vieja salta al recortarse.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0, duration: _scrollDuration, curve: Curves.easeOutCubic);
      }
    });
  }

  static const _scrollDuration = Duration(milliseconds: 450);

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
            if (failure == null) {
              AppToast.showSuccess(context, t.toasts.listUpdated);
            } else {
              AppToast.showError(context, failure.message);
            }
          },
        ),
        BlocListener<SearchFocusCubit, bool>(listenWhen: (_, pending) => pending, listener: (_, _) => _scheduleFocusSearch()),
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
            ProductsSearchBar(controller: _searchController, focusNode: _searchFocus, onOpenFilters: _openFilters),
            ResultsLine(onClearFilters: _clearSearchAndFilters),
            ProductsBody(onClearSearch: _clearSearchAndFilters, onPageChanged: _goToPage),
          ],
        ),
      ),
    );
  }
}
