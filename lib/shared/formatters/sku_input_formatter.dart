import 'package:flutter/services.dart';

class SkuInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    var input = newValue.text.toUpperCase();

    // Replace spaces with dash
    input = input.replaceAll(' ', '-');

    // Keep only A-Z, 0-9, and dash
    input = input.replaceAll(RegExp(r'[^A-Z0-9\-]'), '');

    // Collapse multiple dashes
    input = input.replaceAll(RegExp('-+'), '-');

    // Limit to 20 chars
    if (input.length > 20) {
      return oldValue;
    }

    return TextEditingValue(
      text: input,
      selection: TextSelection.collapsed(offset: input.length),
    );
  }
}
