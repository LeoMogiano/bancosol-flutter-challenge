import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/entities/product_draft.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';
import 'package:warehouse/modules/catalog/domain/validators/product_form_validator.dart';

class CreateProductUseCase {
  const CreateProductUseCase(this._repository);

  final ProductRepository _repository;

  Future<Product> call(ProductDraft draft) async {
    if (!_isValid(draft)) throw const Failure(FailureType.validation);
    return await _repository.createProduct(draft);
  }

  // Duplicados no: requieren el catálogo, que el form ya valida.
  bool _isValid(ProductDraft draft) =>
      validateSku(draft.sku, existingSkus: const []) == null &&
      validateName(draft.name, existingNames: const []) == null &&
      validatePrice(draft.price) == null &&
      validateStock('${draft.stock}') == null;
}
