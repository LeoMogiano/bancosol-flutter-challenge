part of 'delete_product_bloc.dart';

sealed class DeleteProductEvent extends Equatable {
  const DeleteProductEvent();

  @override
  List<Object?> get props => [];
}

final class DeleteProductConfirmed extends DeleteProductEvent {
  const DeleteProductConfirmed();
}
