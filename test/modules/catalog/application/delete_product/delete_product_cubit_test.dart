import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/modules/catalog/application/delete_product/delete_product_cubit.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/usecases/delete_product.dart';

class MockDeleteProduct extends Mock implements DeleteProduct;

void main() {
  group('DeleteProductCubit', () {
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

    blocTest<DeleteProductCubit, DeleteProductState>(
      'si falla la eliminación se puede reintentar',
      build: () {
        when(() => mockDeleteProduct('id1')).thenThrow(const Failure(FailureType.network));
        return DeleteProductCubit(product: product, deleteProduct: mockDeleteProduct);
      },
      act: (cubit) => cubit.confirm(),
      expect: () => [
        const DeleteProductState(submitting: true),
        const DeleteProductState(submitError: Failure(FailureType.network)),
      ],
    );

    blocTest<DeleteProductCubit, DeleteProductState>(
      'si otro usuario ya lo borró (404) se da por eliminado en vez de reintentar para siempre',
      build: () {
        when(() => mockDeleteProduct('id1')).thenThrow(const Failure(FailureType.notFound, statusCode: 404));
        return DeleteProductCubit(product: product, deleteProduct: mockDeleteProduct);
      },
      act: (cubit) => cubit.confirm(),
      verify: (cubit) => expect(cubit.state.deleted, isTrue),
    );
  });
}
