import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/theme/app_dimens.dart';
import 'package:warehouse/core/utils/app_clock.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_products_use_case.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc({
    required GetProductsUseCase getProducts,
    required bool Function() useCache,
    AppClock clock = const AppClock(),
  }) : _getProducts = getProducts,
       _useCache = useCache,
       _clock = clock,
       super(const ProductsState()) {
    on<ProductsRequested>(_onRequested);
    on<ProductsRefreshed>(_onRefreshed);
    on<ProductsQueryChanged>(_onQueryChanged);
    on<ProductsSortChanged>(_onSortChanged);
    on<ProductsFiltersApplied>(_onFiltersApplied);
    on<ProductsPageChanged>(_onPageChanged);
    on<ProductUpserted>(_onUpserted);
    on<ProductRemoved>(_onRemoved);
    on<_HighlightExpired>(_onHighlightExpired);
  }

  final GetProductsUseCase _getProducts;
  final bool Function() _useCache;
  final AppClock _clock;
  Timer? _highlightTimer;

  Future<void> _onRequested(ProductsRequested event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(status: ProductsStatus.loading, failure: () => null));
    await _load(emit);
  }

  Future<void> _onRefreshed(ProductsRefreshed event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(isRefreshing: true, failure: () => null));
    await _load(emit);
  }

  Future<void> _load(Emitter<ProductsState> emit) async {
    try {
      final snapshot = await _getProducts(useCache: _useCache());
      emit(
        _withView(
          state.copyWith(
            status: ProductsStatus.success,
            all: snapshot.products,
            syncedAt: () => snapshot.syncedAt,
            isOffline: snapshot.isOffline,
            isRefreshing: false,
          ),
        ),
      );
    } on Failure catch (failure) {
      // Con datos ya en pantalla, un refresco fallido no los borra: solo se informa.
      final hasData = state.all.isNotEmpty;
      emit(
        state.copyWith(
          status: hasData ? ProductsStatus.success : ProductsStatus.failure,
          failure: () => failure,
          isRefreshing: false,
        ),
      );
    }
  }

  void _onQueryChanged(ProductsQueryChanged event, Emitter<ProductsState> emit) {
    if (event.query == state.query) return;
    emit(_withView(state.copyWith(query: event.query, page: 1)));
  }

  void _onSortChanged(ProductsSortChanged event, Emitter<ProductsState> emit) {
    emit(_withView(state.copyWith(sort: event.sort, page: 1)));
  }

  void _onFiltersApplied(ProductsFiltersApplied event, Emitter<ProductsState> emit) {
    emit(_withView(state.copyWith(filters: event.filters, page: 1)));
  }

  void _onPageChanged(ProductsPageChanged event, Emitter<ProductsState> emit) {
    emit(state.copyWith(page: event.page.clamp(1, state.pageCount)));
  }

  void _onUpserted(ProductUpserted event, Emitter<ProductsState> emit) {
    final product = event.product;
    final exists = state.all.any((p) => p.remoteId == product.remoteId);
    final all = [
      for (final p in state.all)
        if (p.remoteId == product.remoteId) product else p,
      if (!exists) product,
    ];
    emit(_withView(state.copyWith(status: ProductsStatus.success, all: all, highlightId: () => product.remoteId)));

    _highlightTimer?.cancel();
    _highlightTimer = _clock.timer(AppMotion.highlight, () {
      if (!isClosed) add(const _HighlightExpired());
    });
  }

  void _onRemoved(ProductRemoved event, Emitter<ProductsState> emit) {
    emit(_withView(state.copyWith(all: state.all.where((p) => p.remoteId != event.remoteId).toList())));
  }

  void _onHighlightExpired(_HighlightExpired event, Emitter<ProductsState> emit) {
    emit(state.copyWith(highlightId: () => null));
  }

  ProductsState _withView(ProductsState next) {
    final visible = ProductQuery.apply(next.all, query: next.query, sort: next.sort, filters: next.filters);
    return next.copyWith(visible: visible, page: next.page.clamp(1, ProductQuery.pageCount(visible.length)));
  }

  @override
  Future<void> close() {
    _highlightTimer?.cancel();
    return super.close();
  }
}
