enum SkuError { empty, tooShort, invalidFormat, duplicate }

enum NameError { empty, tooShort, onlyDigits, duplicate }

enum StockError { empty, tooHigh }

SkuError? validateSku(String sku, {required Iterable<String> existingSkus}) {
  if (sku.trim().isEmpty) return SkuError.empty;
  if (sku.length < 4) return SkuError.tooShort;
  if (!RegExp(r'^[A-Z0-9]+(-[A-Z0-9]+)*$').hasMatch(sku)) return SkuError.invalidFormat;
  if (existingSkus.any((e) => e.toLowerCase() == sku.toLowerCase())) return SkuError.duplicate;
  return null;
}

NameError? validateName(String name, {required Iterable<String> existingNames}) {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return NameError.empty;
  if (trimmed.length < 3) return NameError.tooShort;
  if (RegExp(r'^[0-9]+$').hasMatch(trimmed)) return NameError.onlyDigits;
  if (existingNames.any((e) => e.toLowerCase().trim() == trimmed.toLowerCase())) return NameError.duplicate;
  return null;
}

StockError? validateStock(String raw) {
  final value = int.tryParse(raw.replaceAll(',', ''));
  if (value == null || value < 0) return StockError.empty;
  if (value > 99999) return StockError.tooHigh;
  return null;
}

bool isValidPriceRange(double? min, double? max) {
  if (min == null || max == null) return true;
  return min <= max;
}
