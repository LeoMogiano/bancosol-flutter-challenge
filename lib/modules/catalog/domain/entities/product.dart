import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.remoteId,
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.currency,
    required this.stock,
  });

  // `_id` de CrudCrud; `id` es el número de negocio del catálogo.
  final String remoteId;
  final int id;
  final String sku;
  final String name;
  final double price;
  final String currency;
  final int stock;

  Product withPrice(double price) =>
      Product(remoteId: remoteId, id: id, sku: sku, name: name, price: price, currency: currency, stock: stock);

  @override
  List<Object?> get props => [remoteId, id, sku, name, price, currency, stock];
}
