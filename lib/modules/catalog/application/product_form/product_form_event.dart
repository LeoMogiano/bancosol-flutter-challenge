part of 'product_form_bloc.dart';

sealed class ProductFormEvent extends Equatable {
  const ProductFormEvent();

  @override
  List<Object?> get props => [];
}

final class ProductFormFieldChanged extends ProductFormEvent {
  const ProductFormFieldChanged(this.field, this.value);

  final ProductField field;
  final String value;

  @override
  List<Object?> get props => [field, value];
}

final class ProductFormCurrencyChanged extends ProductFormEvent {
  const ProductFormCurrencyChanged(this.currency);

  final Currency currency;

  @override
  List<Object?> get props => [currency];
}

final class ProductFormFieldBlurred extends ProductFormEvent {
  const ProductFormFieldBlurred(this.field);

  final ProductField field;

  @override
  List<Object?> get props => [field];
}

final class ProductFormSubmitted extends ProductFormEvent {
  const ProductFormSubmitted();
}
