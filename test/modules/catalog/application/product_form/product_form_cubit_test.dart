import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/modules/catalog/application/product_form/product_form_cubit.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/entities/product_draft.dart';
import 'package:warehouse/modules/catalog/domain/usecases/create_product_use_case.dart';
import 'package:warehouse/modules/catalog/domain/validators/product_form_validator.dart';

class MockCreateProduct extends Mock implements CreateProductUseCase;

class FakeProductDraft extends Fake implements ProductDraft;

void main() {
  setUpAll(() {
    registerFallbackValue(FakeProductDraft());
  });

  group('ProductFormCubit', () {
    late MockCreateProduct mockCreateProduct;
    const existing = [
      Product(remoteId: 'id1', id: 1, sku: 'SKU-001', name: 'Existing', price: 100, currency: 'BOB', stock: 5),
    ];

    setUp(() {
      mockCreateProduct = MockCreateProduct();
    });

    test('los errores aparecen solo al salir del campo o al intentar crear', () async {
      final cubit = ProductFormCubit(existing: existing, createProduct: mockCreateProduct)..skuChanged('');
      expect(cubit.skuError, null);

      cubit.fieldBlurred(ProductField.sku);
      expect(cubit.skuError, SkuError.empty);

      cubit.skuChanged('SKU-002');
      expect(cubit.skuError, null);

      cubit.nameChanged('');
      expect(cubit.nameError, null);

      await cubit.submit();
      expect(cubit.state.submitted, true);
      expect(cubit.nameError, NameError.empty);
    });

    blocTest<ProductFormCubit, ProductFormState>(
      'el nuevo producto toma el siguiente id del catálogo',
      build: () {
        when(() => mockCreateProduct(any())).thenAnswer(
          (_) async => const Product(
            remoteId: 'newId',
            id: 2,
            sku: 'SKU-002',
            name: 'New Product',
            price: 150,
            currency: 'BOB',
            stock: 10,
          ),
        );
        return ProductFormCubit(existing: existing, createProduct: mockCreateProduct);
      },
      act: (cubit) async {
        cubit
          ..skuChanged('SKU-002')
          ..nameChanged('New Product')
          ..priceChanged('150.00')
          ..stockChanged('10');
        await cubit.submit();
      },
      verify: (cubit) {
        final draft = verify(() => mockCreateProduct(captureAny())).captured.single as ProductDraft;
        expect(draft.id, existing.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1);
      },
    );
  });
}
