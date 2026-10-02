import 'package:warehouse/core/constants/app_currency.dart';

enum Currency {
  bob('BOB', 1),
  usd('USD', AppCurrency.usdToBob);

  Currency(this.code, this.toBob);

  final String code;
  final double toBob;

  static Currency? fromCode(String code) {
    final normalized = code.trim().toUpperCase();
    for (final currency in values) {
      if (currency.code == normalized) return currency;
    }
    return null;
  }
}
