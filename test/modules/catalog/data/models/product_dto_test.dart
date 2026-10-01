import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/modules/catalog/data/models/product_dto.dart';

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

  test('el body del PUT no incluye _id', () {
    const dto = ProductDto(
      remoteId: '123',
      id: 1,
      sku: 'SKU-1',
      name: 'Producto',
      price: 10,
      currency: 'BOB',
      stock: 5,
    );
    final json = dto.toJson();

    expect(json.containsKey('_id'), false);
    expect(json, {'id': 1, 'sku': 'SKU-1', 'name': 'Producto', 'price': 10, 'currency': 'BOB', 'stock': 5});
  });
}
