import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/modules/catalog/domain/entities/app_preferences.dart';
import 'package:warehouse/modules/catalog/domain/entities/products_snapshot.dart';
import 'package:warehouse/modules/catalog/domain/repositories/preferences_repository.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_products_use_case.dart';

class _MockProducts extends Mock implements ProductRepository;

class _MockPreferences extends Mock implements PreferencesRepository;

void main() {
  test('con la cache desactivada en Ajustes no la usa', () async {
    final products = _MockProducts();
    final preferences = _MockPreferences();
    when(preferences.load).thenReturn(const AppPreferences(cacheEnabled: false));
    when(() => products.getProducts(useCache: false))
        .thenAnswer((_) async => ProductsSnapshot(products: const [], syncedAt: DateTime(2026)));

    await GetProductsUseCase(products, preferences)();

    verify(() => products.getProducts(useCache: false)).called(1);
  });
}
