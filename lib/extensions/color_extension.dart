import 'package:flutter/material.dart';

extension ColorExtension on Color {
  static Color mix(final Color color, final Color colorToMix, final double fraction) {
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;
    final int rToMix = colorToMix.red;
    final int gToMix = colorToMix.green;
    final int bToMix = colorToMix.blue;

    return Color.fromARGB(
      255,
      _getMixed(r, rToMix, fraction),
      _getMixed(g, gToMix, fraction),
      _getMixed(b, bToMix, fraction),
    );
  }

  static int _getMixed(final int value, final int valueToMix, final double fraction) {
    final double mixedValue = (value - valueToMix) * fraction + valueToMix;
    return mixedValue.toInt();
  }
}
