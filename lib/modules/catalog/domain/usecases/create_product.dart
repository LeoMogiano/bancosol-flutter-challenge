import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/entities/product_draft.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';

class CreateProduct {
  const CreateProduct(this._repository);

  final ProductRepository _repository;

  Future<Product> call(ProductDraft draft) => _repository.createProduct(draft);
}
