import 'package:flutter/services.dart';

class SkuInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    var input = newValue.text.toUpperCase();

    input = input.replaceAll(' ', '-');

    input = input.replaceAll(RegExp(r'[^A-Z0-9\-]'), '');

    input = input.replaceAll(RegExp('-+'), '-');

    if (input.length > 20) return oldValue;

    return TextEditingValue(
      text: input,
      selection: TextSelection.collapsed(offset: input.length),
    );
  }
}
