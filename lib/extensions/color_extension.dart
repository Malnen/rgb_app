import 'dart:math';

import 'package:flutter/material.dart';

extension ColorExtension on Color {
  static Color random([int alpha = 255]) {
    return Color.fromARGB(
      alpha,
      _getRandomColorValue(),
      _getRandomColorValue(),
      _getRandomColorValue(),
    );
  }

  Color mix(Color colorToMix, double fraction) {
    final int rToMix = colorToMix.red;
    final int gToMix = colorToMix.green;
    final int bToMix = colorToMix.blue;

    return Color.fromARGB(
      255,
      _getMixed(red, rToMix, fraction),
      _getMixed(green, gToMix, fraction),
      _getMixed(blue, bToMix, fraction),
    );
  }

  static int _getRandomColorValue() {
    final Random random = Random();
    return random.nextInt(256);
  }

  int _getMixed(int value, int valueToMix, double fraction) {
    final double mixedValue = (value - valueToMix) * fraction + valueToMix;
    return mixedValue.toInt();
  }
}
