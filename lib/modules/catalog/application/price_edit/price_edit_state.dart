part of 'price_edit_bloc.dart';

class PriceEditState extends Equatable {
  const PriceEditState({
    required this.product,
    required this.draft,
    this.submitting = false,
    this.submitError,
    this.saved,
  });

  final Product product;
  final String draft;
  final bool submitting;
  final Failure? submitError;
  final Product? saved;

  PriceEditState copyWith({
    Product? product,
    String? draft,
    bool? submitting,
    Failure? Function()? submitError,
    Product? Function()? saved,
  }) {
    return PriceEditState(
      product: product ?? this.product,
      draft: draft ?? this.draft,
      submitting: submitting ?? this.submitting,
      submitError: submitError != null ? submitError() : this.submitError,
      saved: saved != null ? saved() : this.saved,
    );
  }

  @override
  List<Object?> get props => [product, draft, submitting, submitError, saved];
}
