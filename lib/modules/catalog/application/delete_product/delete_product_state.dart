part of 'delete_product_bloc.dart';

class DeleteProductState extends Equatable {
  const DeleteProductState({this.submitting = false, this.submitError, this.deleted = false});

  final bool submitting;
  final Failure? submitError;
  final bool deleted;

  DeleteProductState copyWith({bool? submitting, Failure? Function()? submitError, bool? deleted}) {
    return DeleteProductState(
      submitting: submitting ?? this.submitting,
      submitError: submitError != null ? submitError() : this.submitError,
      deleted: deleted ?? this.deleted,
    );
  }

  @override
  List<Object?> get props => [submitting, submitError, deleted];
}
