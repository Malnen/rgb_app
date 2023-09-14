import 'dart:math';

import 'package:flutter/material.dart';

extension ColorExtension on Color {
  static Color mix(Color color, Color colorToMix, double fraction) {
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

  static Color random([int alpha = 255]) {
    return Color.fromARGB(
      alpha,
      _getRandomColorValue(),
      _getRandomColorValue(),
      _getRandomColorValue(),
    );
  }

  static int _getMixed(int value, int valueToMix, double fraction) {
    final double mixedValue = (value - valueToMix) * fraction + valueToMix;
    return mixedValue.toInt();
  }

  static int _getRandomColorValue() {
    final Random random = Random();
    return random.nextInt(256);
  }
}
