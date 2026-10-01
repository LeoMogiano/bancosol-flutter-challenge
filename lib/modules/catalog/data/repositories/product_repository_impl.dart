import 'package:warehouse/core/error/failure.dart';
import 'package:warehouse/core/services/logger_service.dart';
import 'package:warehouse/modules/catalog/data/datasources/product_local_data_source.dart';
import 'package:warehouse/modules/catalog/data/datasources/product_remote_data_source.dart';
import 'package:warehouse/modules/catalog/data/models/product_dto.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/entities/product_draft.dart';
import 'package:warehouse/modules/catalog/domain/entities/products_snapshot.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required ProductRemoteDataSource remote,
    required ProductLocalDataSource local,
    DateTime Function()? now,
  }) : _remote = remote,
       _local = local,
       _now = now ?? DateTime.now;

  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;
  final DateTime Function() _now;

  @override
  Future<ProductsSnapshot> getProducts({required bool useCache}) async {
    try {
      final items = await _remote.getAll();
      final syncedAt = _now();
      if (useCache) await _saveCache(items, syncedAt);
      return ProductsSnapshot(products: items.map((e) => e.toDomain()).toList(), syncedAt: syncedAt);
    } on Failure catch (f) {
      if ((f.type == FailureType.network || f.type == FailureType.timeout) && useCache) {
        final cached = _local.read();
        if (cached != null) {
          return ProductsSnapshot(
            products: cached.items.map((e) => e.toDomain()).toList(),
            syncedAt: cached.syncedAt,
            isOffline: true,
          );
        }
      }
      rethrow;
    }
  }

  // El cache es descartable: si no se puede guardar, el listado igual se muestra.
  Future<void> _saveCache(List<ProductDto> items, DateTime syncedAt) async {
    try {
      await _local.save(items, syncedAt);
    } on Failure catch (f) {
      LoggerService.w('Cache no guardado: ${f.detail?.value}', name: 'CATALOG');
    }
  }

  @override
  Future<Product> getProduct(String remoteId) async {
    final dto = await _remote.getById(remoteId);
    return dto.toDomain();
  }

  @override
  Future<void> updatePrice(Product product, double price) async {
    final updated = product.withPrice(price);
    await _remote.update(ProductDto.fromDomain(updated));
  }

  @override
  Future<Product> createProduct(ProductDraft draft) async {
    final dto = await _remote.create(draft);
    return dto.toDomain();
  }

  @override
  Future<void> deleteProduct(String remoteId) async {
    await _remote.delete(remoteId);
  }
}
