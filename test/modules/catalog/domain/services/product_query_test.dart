import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/core/constants/app_currency.dart';
import 'package:warehouse/modules/catalog/domain/entities/currency.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';

void main() {
  group('ProductQuery', () {
    final products = [
      const Product(
        remoteId: '1',
        id: 1,
        sku: 'SKU-1004',
        name: 'Product A',
        price: 100,
        currency: Currency.usd,
        stock: 5,
      ),
      const Product(
        remoteId: '2',
        id: 2,
        sku: 'PROD-2005',
        name: 'Product B',
        price: 200,
        currency: Currency.bob,
        stock: 0,
      ),
      const Product(
        remoteId: '3',
        id: 3,
        sku: 'ABC-3000',
        name: 'Item C',
        price: 50,
        currency: Currency.bob,
        stock: 10,
      ),
    ];

    test('busca por SKU sin guion', () {
      final result = ProductQuery.apply(products, query: '1004');
      expect(result, contains(products[0]));
      expect(result.length, 1);
    });

    test('ordena por precio comparando USD convertido a BOB', () {
      final result = ProductQuery.apply(products, sort: ProductSort.priceAsc);

      final prices = result.map(ProductQuery.priceInBob).toList();
      expect(prices, [50, 200, 100 * AppCurrency.usdToBob]);
    });

    test('filtrar con stock oculta los agotados', () {
      final result = ProductQuery.apply(products, filters: const ProductFilters(inStockOnly: true));

      expect(result, contains(products[0]));
      expect(result, contains(products[2]));
      expect(result, isNot(contains(products[1])));
      expect(result.length, 2);
    });

    test('con precios iguales el orden no cambia entre recargas (desempata por id)', () {
      final tie = [
        for (final id in [3, 1, 2])
          Product(remoteId: '$id', id: id, sku: 'S-$id', name: 'P$id', price: 10, currency: Currency.bob, stock: 1),
      ];

      final ids = ProductQuery.apply(tie, sort: ProductSort.priceDesc).map((p) => p.id);

      expect(ids, [1, 2, 3]);
    });

    test('pagina de 10 en 10', () {
      final bigList = List.generate(25, (i) {
        return Product(
          remoteId: '$i',
          id: i,
          sku: 'SKU-$i',
          name: 'Product $i',
          price: (100 + i).toDouble(),
          currency: Currency.usd,
          stock: 5,
        );
      });

      expect(ProductQuery.pageCount(25), 3);
      expect(ProductQuery.page(bigList, 1).length, 10);
      expect(ProductQuery.page(bigList, 2).length, 10);
      expect(ProductQuery.page(bigList, 3).length, 5);
      expect(ProductQuery.page(bigList, 4), isEmpty);
    });
  });
}
