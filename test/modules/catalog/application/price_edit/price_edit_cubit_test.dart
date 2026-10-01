import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/application/price_edit/price_edit_cubit.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/update_product_price_use_case.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';

class MockUpdateProductPrice extends Mock implements UpdateProductPriceUseCase;

void main() {
  group('PriceEditCubit', () {
    late MockUpdateProductPrice mockUpdatePrice;
    const product = Product(
      remoteId: 'id1',
      id: 1,
      sku: 'SKU-001',
      name: 'Product',
      price: 100,
      currency: 'BOB',
      stock: 5,
    );

    setUp(() {
      mockUpdatePrice = MockUpdateProductPrice();
    });

    test('no deja guardar el mismo precio ni uno inválido', () {
      final cubit = PriceEditCubit(product: product, updatePrice: mockUpdatePrice);

      expect(cubit.state.draft, '100.00');
      expect(cubit.error, PriceError.unchanged);
      expect(cubit.canSubmit, false);

      cubit.draftChanged('200');
      expect(cubit.error, null);
      expect(cubit.canSubmit, true);

      cubit.draftChanged('');
      expect(cubit.error, PriceError.empty);
      expect(cubit.canSubmit, false);
    });

    blocTest<PriceEditCubit, PriceEditState>(
      'un error del servidor deja el borrador para reintentar',
      build: () {
        when(() => mockUpdatePrice(product, any())).thenThrow(const Failure(FailureType.server));
        return PriceEditCubit(product: product, updatePrice: mockUpdatePrice);
      },
      act: (cubit) async {
        cubit.draftChanged('150.00');
        await cubit.submit();
      },
      expect: () => [
        const PriceEditState(product: product, draft: '150.00'),
        const PriceEditState(product: product, draft: '150.00', submitting: true),
        const PriceEditState(product: product, draft: '150.00', submitError: Failure(FailureType.server)),
      ],
    );
  });
}
