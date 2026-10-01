import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/network/api_client.dart';
import 'package:warehouse/core/network/interceptors/retry_interceptor.dart';
import 'package:warehouse/core/network/network_config.dart';

import '../../../helpers/fake_adapter.dart';

ApiClient _client(FakeAdapter adapter) => ApiClient(
  baseUrl: 'https://api.test',
  adapter: adapter,
  interceptors: [RetryInterceptor(sleep: (_) async {})],
);

void main() {
  test('reintenta un GET ante 500 por el mismo cliente y devuelve la respuesta buena', () async {
    final adapter = FakeAdapter([(_) => FakeAdapter.jsonBody(null, status: 500), (_) => FakeAdapter.jsonBody([])]);

    final result = await _client(adapter).get('/products', decode: (d) => d);

    expect(result, isEmpty);
    expect(adapter.calls, 2);
  });

  test('nunca reintenta un POST: duplicaría el producto', () async {
    final adapter = FakeAdapter.json(null, status: 500);

    await expectLater(_client(adapter).post('/products', body: {}, decode: (d) => d), throwsA(isA<Failure>()));
    expect(adapter.calls, 1);
  });

  test('se rinde tras maxRetries y entrega el error', () async {
    final adapter = FakeAdapter.json(null, status: 503);

    await expectLater(_client(adapter).get('/products', decode: (d) => d), throwsA(isA<Failure>()));
    expect(adapter.calls, NetworkConfig.maxRetries + 1);
  });
}
