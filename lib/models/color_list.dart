import 'package:flutter/material.dart';

class ColorList {
  final int height;
  final int width;
  final List<int> _colors;

  ColorList({required this.height, required this.width})
      : _colors = List<int>.filled(width * height, const Color(0xFFFFFFFF).value);

  ColorList copy() => ColorList(
        height: height,
        width: width,
      ).._colors.setAll(0, _colors);

  bool get isEmpty => width <= 0 && height <= 0;

  bool get isNotEmpty => !isEmpty;

  Color getColor(int x, int y) {
    _checkBounds(x, y);
    return Color(_colors[y * width + x]);
  }

  void setColorRGB(int x, int y, int r, int g, int b) {
    _checkBounds(x, y);
    final int argb = (0xFF << 24) | (r << 16) | (g << 8) | b;
    _colors[y * width + x] = argb;
  }

  void setColor(int x, int y, Color color) {
    _checkBounds(x, y);
    _colors[y * width + x] = color.value;
  }

  void _checkBounds(int x, int y) {
    if (x < 0 || x >= width || y < 0 || y >= height) {
      throw RangeError('Coordinates out of bounds: ($x, $y)');
    }
  }
}
