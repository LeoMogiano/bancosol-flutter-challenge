import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/i18n/failure_i18n.dart';
import 'package:warehouse/core/i18n/generated/strings.g.dart';

void main() {
  test('el usuario nunca ve el detalle técnico, solo el mensaje traducido', () async {
    await LocaleSettings.setLocale(AppLocale.es);
    const failure = Failure(FailureType.notFound, statusCode: 404, detail: InternalDetail('PUT /products/x → 404'));

    expect(failure.message, t.failures.notFound);
    expect(failure.message, isNot(contains('/products')));
    expect('${failure.detail}', '[internal]');
  });
}
