import 'package:warehouse/modules/catalog/domain/entities/product.dart';
import 'package:warehouse/modules/catalog/domain/repositories/product_repository.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';

class UpdateProductPriceUseCase {
  const UpdateProductPriceUseCase(this._repository);

  final ProductRepository _repository;

  Future<Product> call(Product product, double newPrice) async {
    final error = validatePrice(newPrice, currency: product.currency, current: product.price);
    if (error != null) {
      throw InvalidPriceException(error);
    }
    await _repository.updatePrice(product, newPrice);
    return product.withPrice(newPrice);
  }
}
