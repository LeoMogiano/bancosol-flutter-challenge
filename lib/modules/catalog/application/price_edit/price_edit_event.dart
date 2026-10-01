part of 'price_edit_bloc.dart';

sealed class PriceEditEvent extends Equatable {
  const PriceEditEvent();

  @override
  List<Object?> get props => [];
}

final class PriceEditDraftChanged extends PriceEditEvent {
  const PriceEditDraftChanged(this.draft);

  final String draft;

  @override
  List<Object?> get props => [draft];
}

final class PriceEditSubmitted extends PriceEditEvent {
  const PriceEditSubmitted();
}
