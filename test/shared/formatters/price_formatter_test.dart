import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/shared/formatters/price_formatter.dart';

void main() {
  group('PriceFormatter', () {
    test('muestra siempre 2 decimales con coma de miles', () {
      expect(PriceFormatter.format(1500.5), '1,500.50');
      expect(PriceFormatter.format(4), '4.00');
      expect(PriceFormatter.format(0), '0.00');
      expect(PriceFormatter.format(999999.99), '999,999.99');
    });
  });
}
