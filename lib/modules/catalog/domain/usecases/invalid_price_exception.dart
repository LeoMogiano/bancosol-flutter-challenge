import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';

class InvalidPriceException implements Exception {
  const InvalidPriceException(this.error);

  final PriceError error;
}
