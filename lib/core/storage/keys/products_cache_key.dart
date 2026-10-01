import 'package:warehouse/core/storage/keys/store_box.dart';
import 'package:warehouse/core/storage/keys/store_key.dart';

enum ProductsCacheKey implements StoreKey {
  items('items'),
  syncedAt('synced_at');

  ProductsCacheKey(this.id);

  @override
  final String id;

  @override
  StoreBox get box => StoreBox.productsCache;
}
