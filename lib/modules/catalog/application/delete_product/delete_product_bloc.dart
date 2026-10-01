import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/delete_product_use_case.dart';

part 'delete_product_event.dart';
part 'delete_product_state.dart';

class DeleteProductBloc extends Bloc<DeleteProductEvent, DeleteProductState> {
  DeleteProductBloc({required Product product, required DeleteProductUseCase deleteProduct})
    : _product = product,
      _deleteProduct = deleteProduct,
      super(const DeleteProductState()) {
    on<DeleteProductConfirmed>(_onConfirmed, transformer: droppable());
  }

  final Product _product;
  final DeleteProductUseCase _deleteProduct;

  Future<void> _onConfirmed(DeleteProductConfirmed event, Emitter<DeleteProductState> emit) async {
    emit(state.copyWith(submitting: true, submitError: () => null));
    try {
      await _deleteProduct(_product.remoteId);
      emit(state.copyWith(submitting: false, deleted: true));
    } on Failure catch (f) {
      // 404: otro usuario ya lo borró; para quien intentaba eliminarlo, el resultado es el mismo.
      f.type == FailureType.notFound
          ? emit(state.copyWith(submitting: false, deleted: true))
          : emit(state.copyWith(submitting: false, submitError: () => f));
    }
  }
}
