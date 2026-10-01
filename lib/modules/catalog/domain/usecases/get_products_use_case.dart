import 'package:warehouse/modules/catalog/domain/entities/products_snapshot.dart';
import 'package:warehouse/modules/catalog/domain/repositories/preferences_repository.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this._products, this._preferences);

  final ProductRepository _products;
  final PreferencesRepository _preferences;

  Future<ProductsSnapshot> call() => _products.getProducts(useCache: _preferences.load().cacheEnabled);
}
