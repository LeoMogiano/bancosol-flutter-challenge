import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/entities/product_draft.dart';
import 'package:warehouse/modules/catalog/domain/usecases/create_product_use_case.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';
import 'package:warehouse/modules/catalog/domain/validators/product_form_validator.dart';

part 'product_form_event.dart';
part 'product_form_state.dart';

enum ProductField { sku, name, price, stock }

class ProductFormBloc extends Bloc<ProductFormEvent, ProductFormState> {
  ProductFormBloc({required List<Product> existing, required CreateProductUseCase createProduct})
    : _existing = existing,
      _createProduct = createProduct,
      super(const ProductFormState()) {
    on<ProductFormFieldChanged>(_onFieldChanged);
    on<ProductFormCurrencyChanged>(_onCurrencyChanged);
    on<ProductFormFieldBlurred>(_onFieldBlurred);
    on<ProductFormSubmitted>(_onSubmitted, transformer: droppable());
  }

  final List<Product> _existing;
  final CreateProductUseCase _createProduct;

  SkuError? get skuError => state.touched.contains(ProductField.sku) || state.submitted
      ? validateSku(state.sku, existingSkus: _existing.map((p) => p.sku))
      : null;

  NameError? get nameError => state.touched.contains(ProductField.name) || state.submitted
      ? validateName(state.name, existingNames: _existing.map((p) => p.name))
      : null;

  PriceError? get priceError => state.touched.contains(ProductField.price) || state.submitted
      ? validatePriceInput(state.price, currency: state.currency)
      : null;

  StockError? get stockError =>
      state.touched.contains(ProductField.stock) || state.submitted ? validateStock(state.stock) : null;

  bool get isValid => skuError == null && nameError == null && priceError == null && stockError == null;

  void _onFieldChanged(ProductFormFieldChanged event, Emitter<ProductFormState> emit) {
    final value = event.value;
    emit(switch (event.field) {
      ProductField.sku => state.copyWith(sku: value),
      ProductField.name => state.copyWith(name: value),
      ProductField.price => state.copyWith(price: value),
      ProductField.stock => state.copyWith(stock: value),
    });
  }

  void _onCurrencyChanged(ProductFormCurrencyChanged event, Emitter<ProductFormState> emit) {
    emit(state.copyWith(currency: event.currency));
  }

  void _onFieldBlurred(ProductFormFieldBlurred event, Emitter<ProductFormState> emit) {
    emit(state.copyWith(touched: {...state.touched, event.field}));
  }

  Future<void> _onSubmitted(ProductFormSubmitted event, Emitter<ProductFormState> emit) async {
    emit(state.copyWith(submitted: true));
    if (!isValid) return;

    emit(state.copyWith(submitting: true));
    try {
      final maxId = _existing.isEmpty ? 0 : _existing.map((p) => p.id).reduce((a, b) => a > b ? a : b);
      final nextId = maxId + 1;
      final parsedPrice = parsePrice(state.price)!;
      final parsedStock = int.parse(state.stock.replaceAll(',', ''));

      final draft = ProductDraft(
        id: nextId,
        sku: state.sku,
        name: state.name,
        price: parsedPrice,
        currency: state.currency,
        stock: parsedStock,
      );

      final created = await _createProduct(draft);
      emit(state.copyWith(submitting: false, created: () => created));
    } on Failure catch (f) {
      emit(state.copyWith(submitting: false, submitError: () => f));
    }
  }
}
