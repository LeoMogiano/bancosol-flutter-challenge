import 'package:equatable/equatable.dart';
import 'package:warehouse/modules/catalog/domain/entities/currency.dart';

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
  final Currency currency;
  final int stock;

  @override
  List<Object?> get props => [id, sku, name, price, currency, stock];
}
