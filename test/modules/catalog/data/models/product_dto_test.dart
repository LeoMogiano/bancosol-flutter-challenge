import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/modules/catalog/data/models/product_dto.dart';
import 'package:warehouse/modules/catalog/domain/entities/currency.dart';

void main() {
  test('acepta precio entero o decimal de la API', () {
    final jsonInt = {
      '_id': '123',
      'id': 1,
      'sku': 'SKU-1',
      'name': 'Producto',
      'price': 10,
      'currency': 'BOB',
      'stock': 5,
    };
    final jsonDouble = {
      '_id': '123',
      'id': 1,
      'sku': 'SKU-1',
      'name': 'Producto',
      'price': 10.5,
      'currency': 'BOB',
      'stock': 5,
    };

    final dtoInt = ProductDto.fromJson(jsonInt);
    final dtoDouble = ProductDto.fromJson(jsonDouble);

    expect(dtoInt.price, 10.0);
    expect(dtoDouble.price, 10.5);
  });

  test('falla si falta un campo obligatorio (no devuelve medio producto)', () {
    expect(
      () => ProductDto.fromJson({
        '_id': '123',
        'id': 1,
        'sku': 'SKU-1',
        'name': 'Producto',
        'price': 10,
        'currency': 'BOB',
      }),
      throwsA(isA<FormatException>().having((e) => e.message, 'message', 'ProductDto.stock')),
    );
  });

  test('falla si la moneda está vacía o no es BOB ni USD', () {
    Map<String, Object?> json(String currency) => {
      '_id': '123',
      'id': 1,
      'sku': 'SKU-1',
      'name': 'Producto',
      'price': 10,
      'currency': currency,
      'stock': 5,
    };
    final currencyError = throwsA(isA<FormatException>().having((e) => e.message, 'message', 'ProductDto.currency'));

    expect(() => ProductDto.fromJson(json('')), currencyError);
    expect(() => ProductDto.fromJson(json('EUR')), currencyError);
    expect(ProductDto.fromJson(json(' usd ')).currency, Currency.usd);
  });

  test('el body del PUT no incluye _id', () {
    const dto = ProductDto(
      remoteId: '123',
      id: 1,
      sku: 'SKU-1',
      name: 'Producto',
      price: 10,
      currency: Currency.bob,
      stock: 5,
    );
    final json = dto.toJson();

    expect(json.containsKey('_id'), false);
    expect(json, {'id': 1, 'sku': 'SKU-1', 'name': 'Producto', 'price': 10, 'currency': 'BOB', 'stock': 5});
  });
}
