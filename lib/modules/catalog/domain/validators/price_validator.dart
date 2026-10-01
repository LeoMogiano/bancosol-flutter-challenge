enum PriceError { empty, incompleteDecimals, notPositive, tooHigh, currencyEmpty, unchanged }

class InvalidPriceException implements Exception {
  const InvalidPriceException(this.error);

  final PriceError error;
}

const double maxPrice = 999999.99;

// double.tryParse aceptaría 'NaN', 'Infinity' o '1e5'.
final RegExp _plainNumber = RegExp(r'^\d+(\.\d{1,2})?$');

double? parsePrice(String raw) {
  final normalized = raw.trim().replaceAll(',', '');
  return _plainNumber.hasMatch(normalized) ? double.parse(normalized) : null;
}

PriceError? validatePrice(double? value, {required String currency, double? current}) {
  if (value == null) return PriceError.empty;
  if (value <= 0) return PriceError.notPositive;
  if (value > maxPrice) return PriceError.tooHigh;
  if (currency.trim().isEmpty) return PriceError.currencyEmpty;
  if (current != null && value == current) return PriceError.unchanged;
  return null;
}

PriceError? validatePriceInput(String raw, {required String currency, double? current}) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return PriceError.empty;
  if (trimmed.endsWith('.')) return PriceError.incompleteDecimals;
  return validatePrice(parsePrice(raw), currency: currency, current: current);
}

// Solo avisa (no bloquea): un cambio grande suele ser un error de tipeo, pero puede ser real.
int? priceChangePercent(double value, double current) {
  if (current <= 0) return null;
  final ratio = (value - current).abs() / current * 100;
  return ratio >= 50 ? ratio.round() : null;
}
