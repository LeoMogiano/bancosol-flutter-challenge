import 'package:warehouse/core/i18n/generated/strings.g.dart';
import 'package:warehouse/modules/catalog/domain/validators/price_validator.dart';
import 'package:warehouse/modules/catalog/domain/validators/product_form_validator.dart';

extension SkuErrorI18n on SkuError {
  String get message => switch (this) {
    SkuError.empty => t.validation.skuEmpty,
    SkuError.tooShort => t.validation.skuTooShort,
    SkuError.invalidFormat => t.validation.skuFormat,
    SkuError.duplicate => t.validation.skuDuplicate,
  };
}

extension NameErrorI18n on NameError {
  String get message => switch (this) {
    NameError.empty => t.validation.nameEmpty,
    NameError.tooShort => t.validation.nameTooShort,
    NameError.onlyDigits => t.validation.nameOnlyDigits,
    NameError.duplicate => t.validation.nameDuplicate,
  };
}

extension PriceErrorI18n on PriceError {
  String get message => switch (this) {
    PriceError.empty => t.validation.priceEmpty,
    PriceError.incompleteDecimals => t.validation.priceIncomplete,
    PriceError.notPositive => t.validation.priceNotPositive,
    PriceError.tooHigh => t.validation.priceTooHigh,
    PriceError.unchanged => t.validation.priceUnchanged,
  };
}

extension StockErrorI18n on StockError {
  String get message => switch (this) {
    StockError.empty => t.validation.stockEmpty,
    StockError.tooHigh => t.validation.stockTooHigh,
  };
}
