import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/currency.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';
import 'package:warehouse/modules/catalog/domain/validators/product_form_validator.dart';

part 'filter_draft_event.dart';
part 'filter_draft_state.dart';

class FilterDraftBloc extends Bloc<FilterDraftEvent, FilterDraftState> {
  FilterDraftBloc({
    required ProductSort sort,
    required ProductFilters filters,
    required this._all,
    required this._query,
  }) : super(
         FilterDraftState(
           sort: sort,
           minText: filters.minPrice != null ? filters.minPrice.toString() : '',
           maxText: filters.maxPrice != null ? filters.maxPrice.toString() : '',
           currency: filters.currency,
           inStockOnly: filters.inStockOnly,
         ),
       ) {
    on<FilterDraftSortChanged>((event, emit) => emit(state.copyWith(sort: event.sort)));
    on<FilterDraftMinChanged>((event, emit) => emit(state.copyWith(minText: event.text)));
    on<FilterDraftMaxChanged>((event, emit) => emit(state.copyWith(maxText: event.text)));
    on<FilterDraftCurrencyChanged>((event, emit) => emit(state.copyWith(currency: () => event.currency)));
    on<FilterDraftInStockToggled>((event, emit) => emit(state.copyWith(inStockOnly: event.inStockOnly)));
    on<FilterDraftReset>((event, emit) => emit(const FilterDraftState()));
  }

  final List<Product> _all;
  final String _query;

  ProductFilters get filters {
    final min = state.minText.isNotEmpty ? parsePrice(state.minText) : null;
    final max = state.maxText.isNotEmpty ? parsePrice(state.maxText) : null;
    return ProductFilters(minPrice: min, maxPrice: max, currency: state.currency, inStockOnly: state.inStockOnly);
  }

  bool get rangeValid {
    final min = state.minText.isNotEmpty ? parsePrice(state.minText) : null;
    final max = state.maxText.isNotEmpty ? parsePrice(state.maxText) : null;
    return isValidPriceRange(min, max);
  }

  int get resultCount {
    return ProductQuery.apply(_all, query: _query, sort: state.sort, filters: filters).length;
  }
}
