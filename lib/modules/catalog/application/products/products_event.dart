part of 'products_bloc.dart';

sealed class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object?> get props => [];
}

final class ProductsRequested extends ProductsEvent {
  const ProductsRequested();
}

// Pull to refresh y "Sincronizar": mantiene la lista visible mientras carga.
final class ProductsRefreshed extends ProductsEvent {
  const ProductsRefreshed();
}

final class ProductsQueryChanged extends ProductsEvent {
  const ProductsQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class ProductsSortChanged extends ProductsEvent {
  const ProductsSortChanged(this.sort);

  final ProductSort sort;

  @override
  List<Object?> get props => [sort];
}

final class ProductsFiltersApplied extends ProductsEvent {
  const ProductsFiltersApplied(this.filters);

  final ProductFilters filters;

  @override
  List<Object?> get props => [filters];
}

final class ProductsPageChanged extends ProductsEvent {
  const ProductsPageChanged(this.page);

  final int page;

  @override
  List<Object?> get props => [page];
}

final class ProductUpserted extends ProductsEvent {
  const ProductUpserted(this.product);

  final Product product;

  @override
  List<Object?> get props => [product];
}

final class ProductRemoved extends ProductsEvent {
  const ProductRemoved(this.remoteId);

  final String remoteId;

  @override
  List<Object?> get props => [remoteId];
}

final class _HighlightExpired extends ProductsEvent {
  const _HighlightExpired();
}
