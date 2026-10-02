import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/network/api_client.dart';
import 'package:warehouse/core/storage/keys/products_cache_key.dart';
import 'package:warehouse/core/storage/keys/store_key.dart';
import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/modules/catalog/data/datasources/product_local_data_source.dart';
import 'package:warehouse/modules/catalog/data/datasources/product_remote_data_source.dart';
import 'package:warehouse/modules/catalog/data/repositories/product_repository_impl.dart';

import '../../../../helpers/fake_adapter.dart';

class _MemoryStore implements LocalStore {
  final Map<StoreKey, Object?> _values = {};

  @override
  T? read<T>(StoreKey key) {
    final value = _values[key];
    return value is T ? value : null;
  }

  @override
  Future<void> write(StoreKey key, Object? value) async => _values[key] = value;

  @override
  Future<void> delete(StoreKey key) async => _values.remove(key);
}

void main() {
  test('sin conexión y con cache activo muestra el último listado como offline', () async {
    final store = _MemoryStore();
    final now = DateTime(2024);

    final api1 = ApiClient(
      baseUrl: 'https://api.test',
      adapter: FakeAdapter.json([
        {'_id': 'a', 'id': 1, 'sku': 'SKU-1', 'name': 'P1', 'price': 10, 'currency': 'BOB', 'stock': 5},
      ]),
    );
    final remote1 = ProductRemoteDataSource(api1);
    final repo1 = ProductRepositoryImpl(remote: remote1, local: ProductLocalDataSource(store), now: () => now);

    final snapshot1 = await repo1.getProducts(useCache: true);
    expect(snapshot1.isOffline, false);
    expect(snapshot1.products.length, 1);
    expect(snapshot1.syncedAt, now);

    final dioError = DioException(
      requestOptions: RequestOptions(path: '/products'),
      type: DioExceptionType.connectionError,
    );
    final api2 = ApiClient(baseUrl: 'https://api.test', adapter: FakeAdapter([(_) => throw dioError]));
    final remote2 = ProductRemoteDataSource(api2);
    final repo2 = ProductRepositoryImpl(remote: remote2, local: ProductLocalDataSource(store), now: () => now);

    final snapshot2 = await repo2.getProducts(useCache: true);
    expect(snapshot2.isOffline, true);
    expect(snapshot2.products.length, 1);
    expect(snapshot2.products.first.name, 'P1');
    expect(snapshot2.syncedAt, now);
  });

  test('un producto con moneda desconocida se descarta sin tumbar el listado', () async {
    final api = ApiClient(
      baseUrl: 'https://api.test',
      adapter: FakeAdapter.json([
        {'_id': 'a', 'id': 1, 'sku': 'SKU-1', 'name': 'P1', 'price': 10, 'currency': 'BOB', 'stock': 5},
        {'_id': 'b', 'id': 2, 'sku': 'SKU-2', 'name': 'P2', 'price': 10, 'currency': 'EUR', 'stock': 5},
      ]),
    );
    final repo = ProductRepositoryImpl(
      remote: ProductRemoteDataSource(api),
      local: ProductLocalDataSource(_MemoryStore()),
      now: () => DateTime(2024),
    );

    final snapshot = await repo.getProducts(useCache: false);
    expect(snapshot.products.map((p) => p.remoteId), ['a']);
  });

  test('un error 500 no se disfraza de offline', () async {
    final store = _MemoryStore();
    final now = DateTime(2024);

    final api1 = ApiClient(
      baseUrl: 'https://api.test',
      adapter: FakeAdapter.json([
        {'_id': 'a', 'id': 1, 'sku': 'SKU-1', 'name': 'P1', 'price': 10, 'currency': 'BOB', 'stock': 5},
      ]),
    );
    final remote1 = ProductRemoteDataSource(api1);
    final repo1 = ProductRepositoryImpl(remote: remote1, local: ProductLocalDataSource(store), now: () => now);

    await repo1.getProducts(useCache: true);

    final api2 = ApiClient(
      baseUrl: 'https://api.test',
      adapter: FakeAdapter([(o) => FakeAdapter.jsonBody(null, status: 500)]),
    );
    final remote2 = ProductRemoteDataSource(api2);
    final repo2 = ProductRepositoryImpl(remote: remote2, local: ProductLocalDataSource(store), now: () => now);

    expect(
      () => repo2.getProducts(useCache: true),
      throwsA(isA<Failure>().having((f) => f.type, 'type', FailureType.server)),
    );
  });

  test('con cache desactivado no guarda nada', () async {
    final store = _MemoryStore();
    final now = DateTime(2024);

    final api = ApiClient(
      baseUrl: 'https://api.test',
      adapter: FakeAdapter.json([
        {'_id': 'a', 'id': 1, 'sku': 'SKU-1', 'name': 'P1', 'price': 10, 'currency': 'BOB', 'stock': 5},
      ]),
    );
    final remote = ProductRemoteDataSource(api);
    final repo = ProductRepositoryImpl(remote: remote, local: ProductLocalDataSource(store), now: () => now);

    await repo.getProducts(useCache: false);

    expect(store.read<Object?>(ProductsCacheKey.items), isNull);
    expect(store.read<Object?>(ProductsCacheKey.syncedAt), isNull);
  });
}
