import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/network/interceptors/redacting_log_interceptor.dart';

void main() {
  test('oculta secretos como texto o como objeto y deja intacto el resto', () {
    final out = RedactingLogInterceptor.redact('{"token":"abc","Api_Key":{"v":1},"name":"Cuaderno"}');

    expect(out, isNot(contains('abc')));
    expect(out, isNot(contains('"v"')));
    expect(out, contains('Cuaderno'));
  });

  test('oculta secretos en la query de la URL', () {
    final out = RedactingLogInterceptor.redactUrl(Uri.parse('https://api.test/p?access_token=abc&q=lapiz'));

    expect(out, isNot(contains('abc')));
    expect(out, contains('q=lapiz'));
  });
}
