import 'package:flutter/services.dart';

class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var input = newValue.text;

    input = input.replaceFirst(RegExp('^ +'), '');

    input = input.replaceAll(RegExp(' {2,}'), ' ');

    if (input.length > 60) {
      return oldValue;
    }

    return TextEditingValue(
      text: input,
      selection: TextSelection.collapsed(offset: input.length),
    );
  }
}
