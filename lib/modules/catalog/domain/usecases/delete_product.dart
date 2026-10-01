import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';

class DeleteProduct {
  const DeleteProduct(this._repository);

  final ProductRepository _repository;

  Future<void> call(String remoteId) => _repository.deleteProduct(remoteId);
}
