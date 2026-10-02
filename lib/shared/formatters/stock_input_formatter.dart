import 'package:flutter/services.dart';

class StockInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    final digitsOnly = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    if (digitsOnly.length > 5) return oldValue;

    String result;
    if (digitsOnly.length <= 3) {
      result = digitsOnly;
    } else if (digitsOnly.length == 4) {
      result = '${digitsOnly.substring(0, 1)},${digitsOnly.substring(1)}';
    } else {
      result = '${digitsOnly.substring(0, 2)},${digitsOnly.substring(2)}';
    }

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
