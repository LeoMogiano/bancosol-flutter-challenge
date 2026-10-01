import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';

void main() {
  group('priceValidator', () {
    test('evalúa el precio en orden: vacío, negativo, muy alto, moneda vacía, sin cambios', () {
      const currency = 'USD';
      expect(validatePrice(null, currency: currency), PriceError.empty);
      expect(validatePrice(0, currency: currency), PriceError.notPositive);
      expect(validatePrice(-5, currency: currency), PriceError.notPositive);
      expect(validatePrice(1000000, currency: currency), PriceError.tooHigh);
      expect(validatePrice(100, currency: ''), PriceError.currencyEmpty);
      expect(validatePrice(100, currency: '   '), PriceError.currencyEmpty);
      expect(validatePrice(100, currency: currency, current: 100), PriceError.unchanged);
      expect(validatePrice(100, currency: currency), null);
    });

    test('un cambio de 50 % o más avisa pero no bloquea', () {
      final percent50 = priceChangePercent(150, 100);
      expect(percent50, 50);
      expect(priceChangePercent(149.6, 100), isNull);
      final percent60Down = priceChangePercent(40, 100);
      expect(percent60Down, 60);
      final percent100 = priceChangePercent(200, 100);
      expect(percent100, 100);
    });
  });
}
