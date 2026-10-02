import 'package:equatable/equatable.dart';
import 'package:warehouse/core/constants/app_currency.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';

enum ProductSort { priceDesc, priceAsc, nameAsc, sku }

class ProductFilters extends Equatable {
  const ProductFilters({this.minPrice, this.maxPrice, this.currency, this.inStockOnly = false});

  static const none = ProductFilters();

  final double? minPrice;
  final double? maxPrice;
  final String? currency;
  final bool inStockOnly;

  int get activeCount {
    var count = 0;
    if (minPrice != null || maxPrice != null) count++;
    if (currency != null) count++;
    if (inStockOnly) count++;
    return count;
  }

  @override
  List<Object?> get props => [minPrice, maxPrice, currency, inStockOnly];
}

abstract final class ProductQuery {
  static const int pageSize = 10;

  static double priceInBob(Product p) {
    return p.currency == 'USD' ? p.price * AppCurrency.usdToBob : p.price;
  }

  static bool matches(Product p, String query) {
    if (query.trim().isEmpty) return true;
    final normalized = query.toLowerCase().replaceAll('-', '').replaceAll(' ', '');
    final nameLower = p.name.toLowerCase().replaceAll('-', '').replaceAll(' ', '');
    final skuLower = p.sku.toLowerCase().replaceAll('-', '').replaceAll(' ', '');
    return nameLower.contains(normalized) || skuLower.contains(normalized);
  }

  static List<Product> apply(
    List<Product> all, {
    String query = '',
    ProductSort sort = ProductSort.nameAsc,
    ProductFilters filters = ProductFilters.none,
  }) {
    var result = all.where((p) => matches(p, query)).toList();

    if (filters.minPrice != null || filters.maxPrice != null) {
      result = result.where((p) {
        final bobPrice = priceInBob(p);
        if (filters.minPrice != null && bobPrice < filters.minPrice!) return false;
        if (filters.maxPrice != null && bobPrice > filters.maxPrice!) return false;
        return true;
      }).toList();
    }

    if (filters.currency != null) {
      result = result.where((p) => p.currency == filters.currency).toList();
    }

    if (filters.inStockOnly) {
      result = result.where((p) => p.stock > 0).toList();
    }

    int primary(Product a, Product b) => switch (sort) {
      ProductSort.priceDesc => priceInBob(b).compareTo(priceInBob(a)),
      ProductSort.priceAsc => priceInBob(a).compareTo(priceInBob(b)),
      ProductSort.nameAsc => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      ProductSort.sku => a.sku.toLowerCase().compareTo(b.sku.toLowerCase()),
    };
    // List.sort no es estable: sin desempate, dos productos iguales cambian de página entre recargas.
    return result..sort((a, b) {
      final byKey = primary(a, b);
      return byKey != 0 ? byKey : a.id.compareTo(b.id);
    });
  }

  static int pageCount(int total) {
    if (total == 0) return 1;
    return (total / pageSize).ceil();
  }

  static List<Product> page(List<Product> items, int pageNumber) {
    if (pageNumber < 1 || pageNumber > pageCount(items.length)) return [];
    final start = (pageNumber - 1) * pageSize;
    final end = (start + pageSize).clamp(0, items.length);
    return items.sublist(start, end);
  }
}
