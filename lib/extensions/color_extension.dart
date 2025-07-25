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
    final int rToMix = colorToMix.redInt;
    final int gToMix = colorToMix.greenInt;
    final int bToMix = colorToMix.blueInt;

    return Color.fromARGB(
      255,
      _getMixed(redInt, rToMix, fraction),
      _getMixed(greenInt, gToMix, fraction),
      _getMixed(blueInt, bToMix, fraction),
    );
  }

  static int _getRandomColorValue() {
    final Random random = Random();
    return random.nextInt(256);
  }

  int get alphaInt => _doubleToInt8(a);

  int get redInt => _doubleToInt8(r);

  int get greenInt => _doubleToInt8(g);

  int get blueInt => _doubleToInt8(b);

  int _doubleToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }

  int _getMixed(int value, int valueToMix, double fraction) {
    final double mixedValue = (value - valueToMix) * fraction + valueToMix;
    return mixedValue.toInt();
  }
}
