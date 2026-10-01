import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/entities/product_draft.dart';
import 'package:warehouse/modules/catalog/domain/entities/products_snapshot.dart';

// Todos los métodos lanzan `Failure`, nunca devuelven errores.
abstract interface class ProductRepository {
  Future<ProductsSnapshot> getProducts({required bool useCache});

  Future<Product> getProduct(String remoteId);

  Future<void> updatePrice(Product product, double price);

  Future<Product> createProduct(ProductDraft draft);

  Future<void> deleteProduct(String remoteId);
}
