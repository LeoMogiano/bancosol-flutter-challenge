import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/repositories/share_repository.dart';

class ShareProduct {
  const ShareProduct(this._repository);

  final ShareRepository _repository;

  Future<bool> call(Product product, {required String text}) => _repository.shareProduct(product, text: text);
}
