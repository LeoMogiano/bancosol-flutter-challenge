import 'package:intl/intl.dart';

abstract final class PriceFormatter {
  static final NumberFormat _format = NumberFormat('#,##0.00', 'en_US');

  static String format(double value) => _format.format(value);
}
