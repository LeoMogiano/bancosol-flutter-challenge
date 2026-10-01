import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/update_product_price_use_case.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';
import 'package:warehouse/shared/formatters/price_formatter.dart';

part 'price_edit_state.dart';

class PriceEditCubit extends Cubit<PriceEditState> {
  PriceEditCubit({required Product product, required UpdateProductPriceUseCase updatePrice})
    : _updatePrice = updatePrice,
      super(PriceEditState(product: product, draft: PriceFormatter.format(product.price)));

  final UpdateProductPriceUseCase _updatePrice;

  PriceError? get error =>
      validatePriceInput(state.draft, currency: state.product.currency, current: state.product.price);

  int? get changePercent {
    final parsed = parsePrice(state.draft);
    if (parsed == null) return null;
    return priceChangePercent(parsed, state.product.price);
  }

  bool get canSubmit => error == null && !state.submitting;

  void draftChanged(String value) {
    emit(state.copyWith(draft: value, submitError: () => null));
  }

  Future<void> submit() async {
    if (!canSubmit) return;
    emit(state.copyWith(submitting: true));
    try {
      final newPrice = parsePrice(state.draft)!;
      final updated = await _updatePrice(state.product, newPrice);
      emit(state.copyWith(submitting: false, saved: () => updated));
    } on InvalidPriceException {
      emit(state.copyWith(submitting: false));
    } on Failure catch (f) {
      emit(state.copyWith(submitting: false, submitError: () => f));
    }
  }
}
