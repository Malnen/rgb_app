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
    if (min < 0) {
      if (newValue.text == '-') {
        return newValue;
      }
    }

    final int newTextLength = newValue.text.length;
    final int? parsedValue = int.tryParse(newValue.text);
    if (newTextLength == 0) {
      return newValue.copyWith(text: '');
    } else if (parsedValue == null) {
      return oldValue;
    } else if (parsedValue < min) {
      return oldValue.copyWith(text: min.toString());
    } else if (parsedValue > max) {
      return oldValue.copyWith(text: max.toString());
    }

    return newValue;
  }
}
