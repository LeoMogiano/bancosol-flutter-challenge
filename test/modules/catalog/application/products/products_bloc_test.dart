import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/utils/app_clock.dart';
import 'package:warehouse/modules/catalog/application/products/products_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/entities/products_snapshot.dart';
import 'package:warehouse/modules/catalog/domain/usecases/get_products_use_case.dart';

class _MockGetProducts extends Mock implements GetProductsUseCase;

// Dispara los timers a mano: probar una ventana de 2.2 s no debe tardar 2.2 s.
class _ManualClock extends AppClock {
  void Function()? pending;

  @override
  Timer timer(Duration duration, void Function() callback) {
    pending = callback;
    return Timer(Duration.zero, () {});
  }
}

Product _product(int id, {String name = 'Producto', double price = 10}) =>
    Product(remoteId: 'r$id', id: id, sku: 'SKU-$id', name: '$name $id', price: price, currency: 'BOB', stock: 5);

void main() {
  late _MockGetProducts getProducts;
  late _ManualClock clock;

  ProductsBloc build() => ProductsBloc(getProducts: getProducts, useCache: () => true, clock: clock);

  setUp(() {
    getProducts = _MockGetProducts();
    clock = _ManualClock();
  });

  blocTest<ProductsBloc, ProductsState>(
    'carga el catálogo y lo muestra ordenado por nombre',
    setUp: () => when(() => getProducts(useCache: true)).thenAnswer(
      (_) async => ProductsSnapshot(
        products: [
          _product(2, name: 'Zapato'),
          _product(1, name: 'Agenda'),
        ],
        syncedAt: DateTime(2026),
      ),
    ),
    build: build,
    act: (bloc) => bloc.add(const ProductsRequested()),
    verify: (bloc) {
      expect(bloc.state.status, ProductsStatus.success);
      expect(bloc.state.pageItems.map((p) => p.id), [1, 2]);
    },
  );

  blocTest<ProductsBloc, ProductsState>(
    'un refresco fallido informa el error sin borrar la lista en pantalla',
    setUp: () => when(() => getProducts(useCache: true)).thenThrow(const Failure(FailureType.server, statusCode: 500)),
    build: build,
    seed: () => ProductsState(status: ProductsStatus.success, all: [_product(1)], visible: [_product(1)]),
    act: (bloc) => bloc.add(const ProductsRefreshed()),
    verify: (bloc) {
      expect(bloc.state.status, ProductsStatus.success);
      expect(bloc.state.all, hasLength(1));
      expect(bloc.state.failure?.type, FailureType.server);
    },
  );

  blocTest<ProductsBloc, ProductsState>(
    'buscar vuelve a la página 1',
    build: build,
    seed: () {
      final all = List.generate(25, _product);
      return ProductsState(status: ProductsStatus.success, all: all, visible: all, page: 3);
    },
    act: (bloc) => bloc.add(const ProductsQueryChanged('Producto 1')),
    verify: (bloc) => expect(bloc.state.page, 1),
  );

  blocTest<ProductsBloc, ProductsState>(
    'el producto editado se resalta y el resaltado se apaga solo',
    build: build,
    seed: () => ProductsState(status: ProductsStatus.success, all: [_product(1)], visible: [_product(1)]),
    act: (bloc) async {
      bloc.add(ProductUpserted(_product(1).withPrice(99)));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state.highlightId, 'r1');
      expect(bloc.state.all.single.price, 99);
      clock.pending!();
    },
    verify: (bloc) => expect(bloc.state.highlightId, isNull),
  );
}
