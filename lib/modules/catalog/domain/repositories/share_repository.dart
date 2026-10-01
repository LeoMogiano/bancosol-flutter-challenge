import 'package:warehouse/modules/catalog/domain/entities/product.dart';

abstract interface class ShareRepository {
  // true solo si la plataforma confirma que se compartió (Android no informa: devuelve false).
  Future<bool> shareProduct(Product product, {required String text});
}
