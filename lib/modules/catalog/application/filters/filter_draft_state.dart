part of 'filter_draft_bloc.dart';

class FilterDraftState extends Equatable {
  const FilterDraftState({
    this.sort = ProductSort.nameAsc,
    this.minText = '',
    this.maxText = '',
    this.currency,
    this.inStockOnly = false,
  });

  final ProductSort sort;
  final String minText;
  final String maxText;
  final Currency? currency;
  final bool inStockOnly;

  FilterDraftState copyWith({
    ProductSort? sort,
    String? minText,
    String? maxText,
    Currency? Function()? currency,
    bool? inStockOnly,
  }) {
    return FilterDraftState(
      sort: sort ?? this.sort,
      minText: minText ?? this.minText,
      maxText: maxText ?? this.maxText,
      currency: currency != null ? currency() : this.currency,
      inStockOnly: inStockOnly ?? this.inStockOnly,
    );
  }

  @override
  List<Object?> get props => [sort, minText, maxText, currency, inStockOnly];
}
