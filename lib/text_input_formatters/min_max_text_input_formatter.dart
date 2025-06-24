import 'package:flutter/services.dart';

class MinMaxTextInputFormatter<T extends num> extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String text = newValue.text;

    if (text.isEmpty || text == '-' || text == '.' || text == '-.') {
      return newValue;
    }

    final num? parsed = num.tryParse(text);
    if (parsed == null) {
      return oldValue;
    }

    return newValue;
  }
}
