import 'package:warehouse/core/storage/local_store.dart';
import 'package:warehouse/modules/catalog/data/models/product_dto.dart';

class ProductLocalDataSource {
  ProductLocalDataSource(this._store);

  final LocalStore _store;

  Future<void> save(List<ProductDto> items, DateTime syncedAt) async {
    final cachedItems = items.map((e) => e.toCacheJson()).toList();
    await _store.write(StoreBox.productsCache, 'items', cachedItems);
    await _store.write(StoreBox.productsCache, 'synced_at', syncedAt.millisecondsSinceEpoch);
  }

  ({List<ProductDto> items, DateTime syncedAt})? read() {
    try {
      final cachedItems = _store.read<List<Object?>>(StoreBox.productsCache, 'items');
      final syncedAtMs = _store.read<int>(StoreBox.productsCache, 'synced_at');

      if (cachedItems == null || syncedAtMs == null) return null;

      final items = [for (final item in cachedItems) ProductDto.fromJson(Map<String, Object?>.from(item! as Map))];

      return (items: items, syncedAt: DateTime.fromMillisecondsSinceEpoch(syncedAtMs));
      // Cache corrupto o de otra versión: se ignora, nunca tumba la app.
    } on Object {
      return null;
    }
  }
}
