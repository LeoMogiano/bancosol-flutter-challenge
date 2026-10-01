import 'package:warehouse/core/network/api_client.dart';
import 'package:warehouse/modules/catalog/data/models/product_dto.dart';
import 'package:warehouse/modules/catalog/domain/entities/product_draft.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource(this._api);

  final ApiClient _api;

  Future<List<ProductDto>> getAll() => _api.get<List<ProductDto>>(
    '/products',
    decode: (data) => (data! as List).map((e) => ProductDto.fromJson(Map<String, Object?>.from(e! as Map))).toList(),
  );

  Future<ProductDto> getById(String id) => _api.get<ProductDto>(
    '/products/$id',
    decode: (data) => ProductDto.fromJson(Map<String, Object?>.from(data! as Map)),
  );

  Future<void> update(ProductDto dto) => _api.put('/products/${dto.remoteId}', body: dto.toJson());

  Future<ProductDto> create(ProductDraft d) => _api.post<ProductDto>(
    '/products',
    body: ProductDto.draftJson(d),
    decode: (data) => ProductDto.fromJson(Map<String, Object?>.from(data! as Map)),
  );

  Future<void> delete(String id) => _api.delete('/products/$id');
}
