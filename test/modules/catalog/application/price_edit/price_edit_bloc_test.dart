import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/application/price_edit/price_edit_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/currency.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/update_product_price_use_case.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';

class MockUpdateProductPrice extends Mock implements UpdateProductPriceUseCase;

void main() {
  group('PriceEditBloc', () {
    late MockUpdateProductPrice mockUpdatePrice;
    const product = Product(
      remoteId: 'id1',
      id: 1,
      sku: 'SKU-001',
      name: 'Product',
      price: 100,
      currency: Currency.bob,
      stock: 5,
    );

    setUp(() {
      mockUpdatePrice = MockUpdateProductPrice();
    });

    test('no deja guardar el mismo precio ni uno inválido', () async {
      final bloc = PriceEditBloc(product: product, updatePrice: mockUpdatePrice);

      expect(bloc.state.draft, '100.00');
      expect(bloc.error, PriceError.unchanged);
      expect(bloc.canSubmit, false);

      bloc.add(const PriceEditDraftChanged('200'));
      await pumpEventQueue();
      expect(bloc.error, null);
      expect(bloc.canSubmit, true);

      bloc.add(const PriceEditDraftChanged(''));
      await pumpEventQueue();
      expect(bloc.error, PriceError.empty);
      expect(bloc.canSubmit, false);
    });

    blocTest<PriceEditBloc, PriceEditState>(
      'un error del servidor deja el borrador para reintentar',
      build: () {
        when(() => mockUpdatePrice(product, any())).thenThrow(const Failure(FailureType.server));
        return PriceEditBloc(product: product, updatePrice: mockUpdatePrice);
      },
      act: (bloc) => bloc
        ..add(const PriceEditDraftChanged('150.00'))
        ..add(const PriceEditSubmitted()),
      expect: () => [
        const PriceEditState(product: product, draft: '150.00'),
        const PriceEditState(product: product, draft: '150.00', submitting: true),
        const PriceEditState(product: product, draft: '150.00', submitError: Failure(FailureType.server)),
      ],
    );
  });
}
