import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/entities/product_draft.dart';

class ProductDto {
  const ProductDto({
    required this.remoteId,
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.currency,
    required this.stock,
  });

  // Un campo obligatorio ausente falla aquí: medio producto rompería pantallas más adelante.
  factory ProductDto.fromJson(Map<String, Object?> json) {
    T field<T>(String key) => json[key] is T ? json[key]! as T : throw FormatException('ProductDto.$key');
    return ProductDto(
      remoteId: field<String>('_id'),
      id: field<num>('id').toInt(),
      sku: field<String>('sku'),
      name: field<String>('name'),
      price: field<num>('price').toDouble(),
      currency: field<String>('currency').toUpperCase(),
      stock: field<num>('stock').toInt(),
    );
  }

  factory ProductDto.fromDomain(Product p) => ProductDto(
    remoteId: p.remoteId,
    id: p.id,
    sku: p.sku,
    name: p.name,
    price: p.price,
    currency: p.currency,
    stock: p.stock,
  );

  final String remoteId;
  final int id;
  final String sku;
  final String name;
  final double price;
  final String currency;
  final int stock;

  // Body de PUT: CrudCrud reemplaza el documento entero y rechaza `_id` en el cuerpo.
  Map<String, Object?> toJson() => {
    'id': id,
    'sku': sku,
    'name': name,
    'price': price,
    'currency': currency,
    'stock': stock,
  };

  Map<String, Object?> toCacheJson() => {'_id': remoteId, ...toJson()};

  Product toDomain() =>
      Product(remoteId: remoteId, id: id, sku: sku, name: name, price: price, currency: currency, stock: stock);

  static Map<String, Object?> draftJson(ProductDraft d) => {
    'id': d.id,
    'sku': d.sku,
    'name': d.name,
    'price': d.price,
    'currency': d.currency,
    'stock': d.stock,
  };
}
