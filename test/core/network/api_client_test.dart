import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/network/api_client.dart';

import '../../helpers/fake_adapter.dart';

ApiClient _client(FakeAdapter adapter) => ApiClient(baseUrl: 'https://api.test', adapter: adapter);

Future<Failure> _failureOf(Future<Object?> call) async {
  try {
    await call;
  } on Failure catch (f) {
    return f;
  }
  throw StateError('se esperaba un Failure');
}

void main() {
  test('traduce cada error de red/HTTP a su FailureType, sin dejar escapar DioException', () async {
    final cases = <FakeReply, FailureType>{
      (o) => throw DioException(requestOptions: o, type: DioExceptionType.receiveTimeout): FailureType.timeout,
      (o) => throw DioException(requestOptions: o, error: const SocketException('offline')): FailureType.network,
      (_) => FakeAdapter.jsonBody(null, status: 404): FailureType.notFound,
      (_) => FakeAdapter.jsonBody(null, status: 429): FailureType.rateLimit,
      (_) => FakeAdapter.jsonBody(null, status: 500): FailureType.server,
    };

    for (final MapEntry(key: reply, value: expected) in cases.entries) {
      final failure = await _failureOf(_client(FakeAdapter([reply])).get('/products', decode: (d) => d));
      expect(failure.type, expected);
    }
  });

  test('una respuesta con forma inesperada sale como parse con la ubicación del fallo', () async {
    final client = _client(FakeAdapter.json({'price': 'no-numero'}));

    final failure = await _failureOf(client.get('/products/1', decode: (d) => (d! as Map)['price'] as num));

    expect(failure.type, FailureType.parse);
    expect(failure.detail!.value, contains('api_client_test.dart'));
  });

  test('PUT de CrudCrud responde sin cuerpo y no se trata como error', () async {
    final client = _client(FakeAdapter.json(null));

    await expectLater(client.put('/products/abc', body: {'price': 5}), completes);
  });
}
