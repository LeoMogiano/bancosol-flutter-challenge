import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/modules/catalog/domain/validators/product_form_validator.dart';

void main() {
  group('productFormValidator', () {
    test('el SKU duplicado se detecta sin importar mayúsculas', () {
      const existingSkus = ['SKU-001', 'PROD-002'];

      expect(validateSku('SKU-001', existingSkus: existingSkus), SkuError.duplicate);
      expect(validateSku('PROD-002', existingSkus: existingSkus), SkuError.duplicate);
      expect(validateSku('SKU-003', existingSkus: existingSkus), null);
    });

    test('el SKU solo admite letras, números y guiones', () {
      expect(validateSku('ABC123', existingSkus: []), null);
      expect(validateSku('ABC-123', existingSkus: []), null);
      expect(validateSku('ABC-123-XYZ', existingSkus: []), null);

      expect(validateSku('ABC_123', existingSkus: []), SkuError.invalidFormat);
      expect(validateSku('ABC@123', existingSkus: []), SkuError.invalidFormat);
      expect(validateSku('abc-123', existingSkus: []), SkuError.invalidFormat);
      expect(validateSku('ABC-', existingSkus: []), SkuError.invalidFormat);
    });

    test('el nombre no puede ser solo números', () {
      expect(validateName('12345', existingNames: []), NameError.onlyDigits);
      expect(validateName('Product', existingNames: []), null);
      expect(validateName('Product 123', existingNames: []), null);
    });
  });
}
