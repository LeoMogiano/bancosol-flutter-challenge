import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/utils/debouncer.dart';

void main() {
  test('con tecleo rápido solo ejecuta la última búsqueda, tras el delay', () {
    fakeAsync((async) {
      final calls = <String>[];
      Debouncer(delay: const Duration(milliseconds: 350))
        ..run(() => calls.add('cu'))
        ..run(() => calls.add('cuaderno'));

      async.elapse(const Duration(milliseconds: 349));
      expect(calls, isEmpty);
      async.elapse(const Duration(milliseconds: 1));
      expect(calls, ['cuaderno']);
    });
  });
}
