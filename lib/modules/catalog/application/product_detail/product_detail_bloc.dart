import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/share_product_use_case.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc({required ShareProductUseCase shareProduct})
    : _shareProduct = shareProduct,
      super(const ProductDetailState()) {
    on<ProductDetailShareRequested>(_onShareRequested, transformer: droppable());
  }

  final ShareProductUseCase _shareProduct;

  Future<void> _onShareRequested(ProductDetailShareRequested event, Emitter<ProductDetailState> emit) async {
    emit(state.copyWith(sharing: true, shareError: () => null));
    try {
      final shared = await _shareProduct(event.product, text: event.text);
      emit(state.copyWith(sharing: false, confirmedShares: state.confirmedShares + (shared ? 1 : 0)));
    } on Failure catch (f) {
      emit(state.copyWith(sharing: false, shareError: () => f));
    }
  }
}
