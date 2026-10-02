import 'package:flutter_test/flutter_test.dart';
import 'package:warehouse/modules/catalog/application/filters/filter_draft_bloc.dart';
import 'package:warehouse/modules/catalog/domain/entities/currency.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/services/product_query.dart';

void main() {
  group('FilterDraftBloc', () {
    test('el contador "Ver N" refleja los filtros sin aplicarlos todavía', () async {
      final products = [
        const Product(
          remoteId: '1',
          id: 1,
          sku: 'SKU-001',
          name: 'Product A',
          price: 100,
          currency: Currency.bob,
          stock: 5,
        ),
        const Product(
          remoteId: '2',
          id: 2,
          sku: 'SKU-002',
          name: 'Product B',
          price: 200,
          currency: Currency.bob,
          stock: 0,
        ),
        const Product(
          remoteId: '3',
          id: 3,
          sku: 'SKU-003',
          name: 'Product C',
          price: 150,
          currency: Currency.bob,
          stock: 10,
        ),
      ];

      final bloc = FilterDraftBloc(sort: ProductSort.nameAsc, filters: ProductFilters.none, all: products, query: '');

      expect(bloc.resultCount, 3);

      bloc.add(const FilterDraftInStockToggled(inStockOnly: true));
      await pumpEventQueue();
      expect(bloc.resultCount, 2);

      bloc.add(const FilterDraftMinChanged('150'));
      await pumpEventQueue();
      expect(bloc.resultCount, 1);
    });

    test('un mínimo mayor que el máximo invalida el rango', () async {
      final products = [
        const Product(
          remoteId: '1',
          id: 1,
          sku: 'SKU-001',
          name: 'Product A',
          price: 100,
          currency: Currency.bob,
          stock: 5,
        ),
      ];

      final bloc = FilterDraftBloc(sort: ProductSort.nameAsc, filters: ProductFilters.none, all: products, query: '')
        ..add(const FilterDraftMinChanged('200'))
        ..add(const FilterDraftMaxChanged('100'));
      await pumpEventQueue();

      expect(bloc.rangeValid, false);
    });
  });
}
