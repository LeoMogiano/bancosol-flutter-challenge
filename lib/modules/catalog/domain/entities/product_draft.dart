import 'package:equatable/equatable.dart';

class ProductDraft extends Equatable {
  const ProductDraft({
    required this.id,
    required this.sku,
    required this.name,
    required this.price,
    required this.currency,
    required this.stock,
  });

  final int id;
  final String sku;
  final String name;
  final double price;
  final String currency;
  final int stock;

  @override
  List<Object?> get props => [id, sku, name, price, currency, stock];
}
