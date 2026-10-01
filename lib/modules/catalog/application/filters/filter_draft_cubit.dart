import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';
import 'package:warehouse/modules/catalog/domain/validators/product_form_validator.dart';

part 'filter_draft_state.dart';

class FilterDraftCubit extends Cubit<FilterDraftState> {
  FilterDraftCubit({
    required ProductSort sort,
    required ProductFilters filters,
    required List<Product> all,
    required String query,
  }) : _all = all,
       _query = query,
       super(
         FilterDraftState(
           sort: sort,
           minText: filters.minPrice != null ? filters.minPrice.toString() : '',
           maxText: filters.maxPrice != null ? filters.maxPrice.toString() : '',
           currency: filters.currency,
           inStockOnly: filters.inStockOnly,
         ),
       );

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

  void sortChanged(ProductSort sort) {
    emit(state.copyWith(sort: sort));
  }

  void minChanged(String value) {
    emit(state.copyWith(minText: value));
  }

  void maxChanged(String value) {
    emit(state.copyWith(maxText: value));
  }

  void currencyChanged(String? currency) {
    emit(state.copyWith(currency: () => currency));
  }

  void inStockChanged(bool value) {
    emit(state.copyWith(inStockOnly: value));
  }

  void reset() {
    emit(const FilterDraftState());
  }
}
