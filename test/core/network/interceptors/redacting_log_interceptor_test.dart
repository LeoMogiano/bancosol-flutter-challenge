import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/network/interceptors/redacting_log_interceptor.dart';

void main() {
  test('oculta secretos como texto o como objeto y deja intacto el resto', () {
    final out = RedactingLogInterceptor.redact('{"token":"abc","Api_Key":{"v":1},"name":"Cuaderno"}');

    expect(out, isNot(contains('abc')));
    expect(out, isNot(contains('"v"')));
    expect(out, contains('Cuaderno'));
  });
}
