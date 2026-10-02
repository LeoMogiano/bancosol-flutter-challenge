part of 'filter_draft_bloc.dart';

sealed class FilterDraftEvent extends Equatable {
  const FilterDraftEvent();

  @override
  List<Object?> get props => [];
}

final class FilterDraftSortChanged extends FilterDraftEvent {
  const FilterDraftSortChanged(this.sort);

  final ProductSort sort;

  @override
  List<Object?> get props => [sort];
}

final class FilterDraftMinChanged extends FilterDraftEvent {
  const FilterDraftMinChanged(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

final class FilterDraftMaxChanged extends FilterDraftEvent {
  const FilterDraftMaxChanged(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}

final class FilterDraftCurrencyChanged extends FilterDraftEvent {
  const FilterDraftCurrencyChanged(this.currency);

  final Currency? currency;

  @override
  List<Object?> get props => [currency];
}

final class FilterDraftInStockToggled extends FilterDraftEvent {
  const FilterDraftInStockToggled({required this.inStockOnly});

  final bool inStockOnly;

  @override
  List<Object?> get props => [inStockOnly];
}

final class FilterDraftReset extends FilterDraftEvent {
  const FilterDraftReset();
}
