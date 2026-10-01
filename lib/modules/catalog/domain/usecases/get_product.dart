import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';

class GetProduct {
  const GetProduct(this._repository);

  final ProductRepository _repository;

  Future<Product> call(String remoteId) => _repository.getProduct(remoteId);
}
