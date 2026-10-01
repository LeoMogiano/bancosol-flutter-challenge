import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/shared/formatters/stock_input_formatter.dart';

String type(TextInputFormatter f, String old, String next) =>
    f.formatEditUpdate(TextEditingValue(text: old), TextEditingValue(text: next)).text;

void main() {
  group('StockInputFormatter', () {
    late StockInputFormatter formatter;

    setUp(() {
      formatter = StockInputFormatter();
    });

    test('separa miles y limita a 5 dígitos', () {
      expect(type(formatter, '', '1'), '1');
      expect(type(formatter, '1', '12'), '12');
      expect(type(formatter, '12', '123'), '123');
      expect(type(formatter, '123', '1234'), '1,234');
      expect(type(formatter, '1,234', '12345'), '12,345');
      expect(type(formatter, '12,345', '123456'), '12,345');
    });
  });
}
