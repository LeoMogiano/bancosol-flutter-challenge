import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';
import 'package:warehouse/modules/catalog/domain/usecases/update_product_price_use_case.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';

class _MockProductRepository extends Mock implements ProductRepository;

class _FakeProduct extends Fake implements Product;

void main() {
  group('UpdateProductPriceUseCase', () {
    late ProductRepository repository;
    late UpdateProductPriceUseCase useCase;
    late Product product;

    setUpAll(() {
      registerFallbackValue(_FakeProduct());
    });

    setUp(() {
      repository = _MockProductRepository();
      useCase = UpdateProductPriceUseCase(repository);
      product = const Product(
        remoteId: 'id1',
        id: 1,
        sku: 'SKU-001',
        name: 'Product',
        price: 100,
        currency: 'USD',
        stock: 10,
      );
    });

    test('valida el precio antes de tocar la red', () async {
      expect(() => useCase(product, 0), throwsA(isA<InvalidPriceException>()));
      verifyNever(() => repository.updatePrice(any(), any()));
    });

    test('actualiza solo el precio del producto', () async {
      when(() => repository.updatePrice(any(), any())).thenAnswer((_) async {});

      final result = await useCase(product, 150);

      expect(result.price, 150.0);
      expect(result.remoteId, product.remoteId);
      expect(result.sku, product.sku);
      verify(() => repository.updatePrice(product, 150)).called(1);
    });
  });
}
