import 'package:flutter/services.dart';

class MinMaxTextInputFormatter<T extends num> extends TextInputFormatter {
  final T min;
  final T max;

  MinMaxTextInputFormatter({required this.min, required this.max});

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
      return newValue;
    }

    if (parsed < min || parsed > max) {
      return oldValue;
    }

    return newValue;
  }
}
