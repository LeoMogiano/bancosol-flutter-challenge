import 'package:equatable/equatable.dart';
import 'package:warehouse/modules/catalog/domain/entities/product.dart';

class ProductsSnapshot extends Equatable {
  const ProductsSnapshot({required this.products, required this.syncedAt, this.isOffline = false});

  final List<Product> products;
  final DateTime syncedAt;

  // true = la API falló y se muestra el último listado guardado.
  final bool isOffline;

  @override
  List<Object?> get props => [products, syncedAt, isOffline];
}
