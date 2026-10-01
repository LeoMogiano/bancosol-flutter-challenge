import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/network/api_client.dart';
import 'package:warehouse/core/network/interceptors/api_key_interceptor.dart';

import '../../../helpers/fake_adapter.dart';

Future<Map<String, dynamic>> _sentHeaders(String apiKey) async {
  late Map<String, dynamic> headers;
  final adapter = FakeAdapter([
    (o) {
      headers = o.headers;
      return FakeAdapter.jsonBody([]);
    },
  ]);
  await ApiClient(
    baseUrl: 'https://api.test',
    adapter: adapter,
    interceptors: [ApiKeyInterceptor(apiKey)],
  ).get('/products', decode: (d) => d);
  return headers;
}

void main() {
  test('envía x-api-key solo cuando el ambiente define una', () async {
    expect((await _sentHeaders('k-123'))[ApiKeyInterceptor.header], 'k-123');
    expect((await _sentHeaders('')).containsKey(ApiKeyInterceptor.header), isFalse);
  });
}
