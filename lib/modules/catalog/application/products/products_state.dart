part of 'products_bloc.dart';

enum ProductsStatus { loading, refreshing, success, failure }

enum ProductsView { loading, error, empty, noResults, list }

class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsStatus.loading,
    this.all = const [],
    this.visible = const [],
    this.query = '',
    this.sort = ProductSort.nameAsc,
    this.filters = ProductFilters.none,
    this.page = 1,
    this.pageItems = const [],
    this.syncedAt,
    this.isOffline = false,
    this.failure,
    this.highlightId,
  });

  final ProductsStatus status;
  final List<Product> all;

  // `all` ya buscado, filtrado y ordenado; se recalcula solo cuando cambia algo que lo afecta.
  final List<Product> visible;
  final String query;
  final ProductSort sort;
  final ProductFilters filters;
  final int page;

  // Se guarda (no getter) para que la instancia no cambie entre emisiones y `select` no reconstruya la lista.
  final List<Product> pageItems;
  final DateTime? syncedAt;
  final bool isOffline;
  final Failure? failure;
  final String? highlightId;

  bool get isLoading => status == ProductsStatus.loading || isRefreshing;

  bool get isRefreshing => status == ProductsStatus.refreshing;

  ProductsView get view {
    if (isLoading) return ProductsView.loading;
    if (status == ProductsStatus.failure) return ProductsView.error;
    if (all.isEmpty) return ProductsView.empty;
    if (visible.isEmpty) return ProductsView.noResults;
    return ProductsView.list;
  }

  int get pageCount => ProductQuery.pageCount(visible.length);

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? all,
    List<Product>? visible,
    String? query,
    ProductSort? sort,
    ProductFilters? filters,
    int? page,
    List<Product>? pageItems,
    DateTime? Function()? syncedAt,
    bool? isOffline,
    Failure? Function()? failure,
    String? Function()? highlightId,
  }) {
    return ProductsState(
      status: status ?? this.status,
      all: all ?? this.all,
      visible: visible ?? this.visible,
      query: query ?? this.query,
      sort: sort ?? this.sort,
      filters: filters ?? this.filters,
      page: page ?? this.page,
      pageItems: pageItems ?? this.pageItems,
      syncedAt: syncedAt != null ? syncedAt() : this.syncedAt,
      isOffline: isOffline ?? this.isOffline,
      failure: failure != null ? failure() : this.failure,
      highlightId: highlightId != null ? highlightId() : this.highlightId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    all,
    visible,
    query,
    sort,
    filters,
    page,
    pageItems,
    syncedAt,
    isOffline,
    failure,
    highlightId,
  ];
}
