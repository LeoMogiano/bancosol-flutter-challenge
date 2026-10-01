import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/application/delete_product/delete_product_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/delete_product_use_case.dart';

class MockDeleteProduct extends Mock implements DeleteProductUseCase;

void main() {
  group('DeleteProductBloc', () {
    late MockDeleteProduct mockDeleteProduct;
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
      mockDeleteProduct = MockDeleteProduct();
    });

    blocTest<DeleteProductBloc, DeleteProductState>(
      'si falla la eliminación se puede reintentar',
      build: () {
        when(() => mockDeleteProduct('id1')).thenThrow(const Failure(FailureType.network));
        return DeleteProductBloc(product: product, deleteProduct: mockDeleteProduct);
      },
      act: (bloc) => bloc.add(const DeleteProductConfirmed()),
      expect: () => [
        const DeleteProductState(submitting: true),
        const DeleteProductState(submitError: Failure(FailureType.network)),
      ],
    );

    blocTest<DeleteProductBloc, DeleteProductState>(
      'si otro usuario ya lo borró (404) se da por eliminado en vez de reintentar para siempre',
      build: () {
        when(() => mockDeleteProduct('id1')).thenThrow(const Failure(FailureType.notFound, statusCode: 404));
        return DeleteProductBloc(product: product, deleteProduct: mockDeleteProduct);
      },
      act: (bloc) => bloc.add(const DeleteProductConfirmed()),
      verify: (bloc) => expect(bloc.state.deleted, isTrue),
    );
  });
}
