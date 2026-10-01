import 'package:warehouse/core/services/share_service.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/repositories/share_repository.dart';

class ShareRepositoryImpl implements ShareRepository {
  const ShareRepositoryImpl(this._service);

  final ShareService _service;

  @override
  Future<bool> shareProduct(Product product, {required String text}) => _service.shareText(text, subject: product.name);
}
