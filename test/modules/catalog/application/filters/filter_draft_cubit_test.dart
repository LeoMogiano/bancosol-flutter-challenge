import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/modules/catalog/application/filters/filter_draft_cubit.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';

void main() {
  group('FilterDraftCubit', () {
    test('el contador "Ver N" refleja los filtros sin aplicarlos todavía', () {
      final products = [
        const Product(remoteId: '1', id: 1, sku: 'SKU-001', name: 'Product A', price: 100, currency: 'BOB', stock: 5),
        const Product(remoteId: '2', id: 2, sku: 'SKU-002', name: 'Product B', price: 200, currency: 'BOB', stock: 0),
        const Product(remoteId: '3', id: 3, sku: 'SKU-003', name: 'Product C', price: 150, currency: 'BOB', stock: 10),
      ];

      final cubit = FilterDraftCubit(sort: ProductSort.nameAsc, filters: ProductFilters.none, all: products, query: '');

      expect(cubit.resultCount, 3);

      cubit.inStockChanged(true);
      expect(cubit.resultCount, 2);

      cubit.minChanged('150');
      expect(cubit.resultCount, 1);
    });

    test('un mínimo mayor que el máximo invalida el rango', () {
      final products = [
        const Product(remoteId: '1', id: 1, sku: 'SKU-001', name: 'Product A', price: 100, currency: 'BOB', stock: 5),
      ];

      final cubit = FilterDraftCubit(sort: ProductSort.nameAsc, filters: ProductFilters.none, all: products, query: '')
        ..minChanged('200')
        ..maxChanged('100');

      expect(cubit.rangeValid, false);
    });
  });
}
