import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:warehouse/app/sentry_config.dart';

void main() {
  test('la api key nunca viaja a Sentry dentro de un breadcrumb HTTP', () {
    final crumb = Breadcrumb.http(url: Uri.parse('https://api.test/products'), method: 'GET')
      ..data = {
        'x-api-key': 'secreto',
        'headers': {'x-api-key': 'secreto', 'accept': 'json'},
      };

    final clean = redactBreadcrumb(crumb, Hint())!;

    expect(clean.data.toString(), isNot(contains('secreto')));
    expect((clean.data!['headers'] as Map)['accept'], 'json');
  });
}
