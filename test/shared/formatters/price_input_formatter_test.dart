import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/shared/formatters/price_input_formatter.dart';

String type(TextInputFormatter f, String old, String next) =>
    f.formatEditUpdate(TextEditingValue(text: old), TextEditingValue(text: next)).text;

void main() {
  group('PriceInputFormatter', () {
    late PriceInputFormatter formatter;

    setUp(() {
      formatter = PriceInputFormatter();
    });

    test('separa miles solo', () {
      expect(type(formatter, '', '1'), '1');
      expect(type(formatter, '1', '15'), '15');
      expect(type(formatter, '15', '150'), '150');
      expect(type(formatter, '150', '1500'), '1,500');
      expect(type(formatter, '1,500', '15000'), '15,000');
      expect(type(formatter, '15,000', '150000'), '150,000');
    });

    test('coma o punto tecleados son el separador decimal', () {
      expect(type(formatter, '1,500', '1,500,'), '1,500.');
      expect(type(formatter, '1,500.', '1,500.5'), '1,500.5');
    });

    test('bloquea un tercer decimal y más de 6 dígitos enteros', () {
      expect(type(formatter, '1.25', '1.255'), '1.25');
      expect(type(formatter, '999,999', '9,999,999'), '999,999');
    });

    test('al borrar en medio del número el cursor se queda en su cifra', () {
      final result = formatter.formatEditUpdate(
        const TextEditingValue(text: '12,345'),
        const TextEditingValue(text: '1,345', selection: TextSelection.collapsed(offset: 1)),
      );

      expect(result.text, '1,345');
      expect(result.selection.baseOffset, 1);
    });

    test('quita ceros a la izquierda y completa .5 a 0.5', () {
      expect(type(formatter, '', '0'), '0');
      expect(type(formatter, '0', '007'), '7');
      expect(type(formatter, '', '.'), '0.');
      expect(type(formatter, '0.', '0.5'), '0.5');
    });
  });
}
