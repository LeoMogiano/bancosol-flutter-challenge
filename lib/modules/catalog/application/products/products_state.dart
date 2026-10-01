part of 'products_bloc.dart';

enum ProductsStatus { initial, loading, success, failure }

class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsStatus.initial,
    this.all = const [],
    this.visible = const [],
    this.query = '',
    this.sort = ProductSort.nameAsc,
    this.filters = ProductFilters.none,
    this.page = 1,
    this.syncedAt,
    this.isOffline = false,
    this.isRefreshing = false,
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
  final DateTime? syncedAt;
  final bool isOffline;
  final bool isRefreshing;
  final Failure? failure;
  final String? highlightId;

  int get pageCount => ProductQuery.pageCount(visible.length);

  List<Product> get pageItems => ProductQuery.page(visible, page);

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? all,
    List<Product>? visible,
    String? query,
    ProductSort? sort,
    ProductFilters? filters,
    int? page,
    DateTime? Function()? syncedAt,
    bool? isOffline,
    bool? isRefreshing,
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
      syncedAt: syncedAt != null ? syncedAt() : this.syncedAt,
      isOffline: isOffline ?? this.isOffline,
      isRefreshing: isRefreshing ?? this.isRefreshing,
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
    syncedAt,
    isOffline,
    isRefreshing,
    failure,
    highlightId,
  ];
}
