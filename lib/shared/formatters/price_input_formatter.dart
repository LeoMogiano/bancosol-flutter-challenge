import 'package:flutter/services.dart';

// Coma = miles (automática), punto = decimal. Una `,` o `.` tecleada al final se toma como decimal.
class PriceInputFormatter extends TextInputFormatter {
  static const int _maxIntegerDigits = 6;
  static final RegExp _valid = RegExp(r'^\d*(\.\d{0,2})?$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final typedSeparator =
        newValue.text.length == oldValue.text.length + 1 &&
        newValue.text.startsWith(oldValue.text) &&
        (newValue.text.endsWith(',') || newValue.text.endsWith('.'));
    final raw = typedSeparator ? '${_stripGrouping(oldValue.text)}.' : _stripGrouping(newValue.text);
    if (!_valid.hasMatch(raw)) return oldValue;

    final dot = raw.indexOf('.');
    final integer = (dot == -1 ? raw : raw.substring(0, dot)).replaceFirst(RegExp('^0+(?=.)'), '');
    if (integer.length > _maxIntegerDigits) return oldValue;

    final decimals = dot == -1 ? '' : raw.substring(dot);
    final text = raw.isEmpty ? '' : '${_group(integer.isEmpty ? '0' : integer)}$decimals';
    final cursor = typedSeparator ? text.length : _cursorKeeping(_significantAfterCursor(newValue), text);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: cursor),
    );
  }

  // Mantiene el cursor sobre la misma cifra aunque se agreguen o quiten comas de miles.
  static int _significantAfterCursor(TextEditingValue value) {
    final end = value.selection.end;
    if (end < 0 || end > value.text.length) return 0;
    return value.text.substring(end).replaceAll(',', '').length;
  }

  static int _cursorKeeping(int significantAfter, String text) {
    var remaining = significantAfter;
    var i = text.length;
    while (i > 0 && remaining > 0) {
      if (text[i - 1] != ',') remaining--;
      i--;
    }
    while (i > 0 && text[i - 1] == ',') {
      i--;
    }
    return i;
  }

  static String _stripGrouping(String text) => text.replaceAll(',', '');

  static String _group(String digits) => digits.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');
}
