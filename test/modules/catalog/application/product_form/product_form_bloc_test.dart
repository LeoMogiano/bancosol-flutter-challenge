import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/modules/catalog/application/product_form/product_form_bloc.dart';
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

  group('ProductFormBloc', () {
    late MockCreateProduct mockCreateProduct;
    const existing = [
      Product(remoteId: 'id1', id: 1, sku: 'SKU-001', name: 'Existing', price: 100, currency: 'BOB', stock: 5),
    ];

    setUp(() {
      mockCreateProduct = MockCreateProduct();
    });

    test('los errores aparecen solo al salir del campo o al intentar crear', () async {
      final bloc = ProductFormBloc(existing: existing, createProduct: mockCreateProduct)
        ..add(const ProductFormFieldChanged(ProductField.sku, ''));
      await pumpEventQueue();
      expect(bloc.skuError, null);

      bloc.add(const ProductFormFieldBlurred(ProductField.sku));
      await pumpEventQueue();
      expect(bloc.skuError, SkuError.empty);

      bloc.add(const ProductFormFieldChanged(ProductField.sku, 'SKU-002'));
      await pumpEventQueue();
      expect(bloc.skuError, null);

      bloc.add(const ProductFormFieldChanged(ProductField.name, ''));
      await pumpEventQueue();
      expect(bloc.nameError, null);

      bloc.add(const ProductFormSubmitted());
      await pumpEventQueue();
      expect(bloc.state.submitted, true);
      expect(bloc.nameError, NameError.empty);
    });

    blocTest<ProductFormBloc, ProductFormState>(
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
        return ProductFormBloc(existing: existing, createProduct: mockCreateProduct);
      },
      act: (bloc) => bloc
        ..add(const ProductFormFieldChanged(ProductField.sku, 'SKU-002'))
        ..add(const ProductFormFieldChanged(ProductField.name, 'New Product'))
        ..add(const ProductFormFieldChanged(ProductField.price, '150.00'))
        ..add(const ProductFormFieldChanged(ProductField.stock, '10'))
        ..add(const ProductFormSubmitted()),
      verify: (_) {
        final draft = verify(() => mockCreateProduct(captureAny())).captured.single as ProductDraft;
        expect(draft.id, existing.map((p) => p.id).reduce((a, b) => a > b ? a : b) + 1);
      },
    );
  });
}
