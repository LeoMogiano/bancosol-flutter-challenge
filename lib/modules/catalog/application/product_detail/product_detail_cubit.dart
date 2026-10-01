import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/share_product_use_case.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit({required ShareProductUseCase shareProduct})
    : _shareProduct = shareProduct,
      super(const ProductDetailState());

  final ShareProductUseCase _shareProduct;

  Future<void> share(Product product, {required String text}) async {
    emit(state.copyWith(sharing: true, shareError: () => null));
    try {
      final shared = await _shareProduct(product, text: text);
      if (isClosed) return;
      emit(state.copyWith(sharing: false, confirmedShares: state.confirmedShares + (shared ? 1 : 0)));
    } on Failure catch (f) {
      if (isClosed) return;
      emit(state.copyWith(sharing: false, shareError: () => f));
    }
  }
}
