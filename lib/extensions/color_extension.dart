import 'package:flutter/material.dart';

extension ColorExtension on Color {
  static Color mix(Color color, Color colorToMix, double fraction) {
    int r = color.red;
    int g = color.green;
    int b = color.blue;
    int rToMix = colorToMix.red;
    int gToMix = colorToMix.green;
    int bToMix = colorToMix.blue;

    return Color.fromARGB(
      255,
      _getMixed(r, rToMix, fraction),
      _getMixed(g, gToMix, fraction),
      _getMixed(b, bToMix, fraction),
    );
  }

  static int _getMixed(int value, int valueToMix, double fraction) {
    double mixedValue = (value - valueToMix) * fraction + valueToMix;

    return mixedValue.toInt();
  }
}
