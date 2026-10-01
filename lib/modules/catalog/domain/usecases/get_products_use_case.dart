import 'package:warehouse/modules/catalog/domain/entities/products_snapshot.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this._repository);

  final ProductRepository _repository;

  Future<ProductsSnapshot> call({required bool useCache}) => _repository.getProducts(useCache: useCache);
}
