import 'package:flutter/services.dart';

class MinMaxTextInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  MinMaxTextInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final int newTextLength = newValue.text.length;

    final int? parsedValue = int.tryParse(newValue.text);
    if (newTextLength == 0) {
      return newValue.copyWith(text: '');
    } else if (parsedValue == null) {
      return oldValue;
    } else if (parsedValue < min) {
      return oldValue;
    } else if (parsedValue > max) {
      return oldValue;
    }

    return newValue;
  }
}
