import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/shared/formatters/sku_input_formatter.dart';

String type(TextInputFormatter f, String old, String next) =>
    f.formatEditUpdate(TextEditingValue(text: old), TextEditingValue(text: next)).text;

void main() {
  group('SkuInputFormatter', () {
    late SkuInputFormatter formatter;

    setUp(() {
      formatter = SkuInputFormatter();
    });

    test('normaliza a mayúsculas con guiones', () {
      expect(type(formatter, '', 'sku 10'), 'SKU-10');
      expect(type(formatter, 'a', 'a--b'), 'A-B');
      expect(type(formatter, '', 'abc123'), 'ABC123');
      expect(type(formatter, '', 'a b c'), 'A-B-C');
    });
  });
}
