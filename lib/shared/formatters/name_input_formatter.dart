import 'package:flutter/services.dart';

class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var input = newValue.text;

    // Remove leading spaces
    input = input.replaceFirst(RegExp('^ +'), '');

    // Collapse multiple spaces to one
    input = input.replaceAll(RegExp(' {2,}'), ' ');

    // Limit to 60 chars
    if (input.length > 60) {
      return oldValue;
    }

    return TextEditingValue(
      text: input,
      selection: TextSelection.collapsed(offset: input.length),
    );
  }
}
