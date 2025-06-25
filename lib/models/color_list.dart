import 'package:flutter/material.dart';

class ColorList {
  final int width;
  final int height;
  final int depth;
  final List<int> _colors;

  ColorList({
    required this.width,
    required this.height,
    required this.depth,
  }) : _colors = List<int>.filled(width * height * depth, const Color(0xFFFFFFFF).toARGB32());

  ColorList copy() => ColorList(
        width: width,
        height: height,
        depth: depth,
      ).._colors.setAll(0, _colors);

  bool get isEmpty => width <= 0 || height <= 0 || depth <= 0;

  bool get isNotEmpty => !isEmpty;

  Color getColor(int x, int y, int z) {
    _checkBounds(x, y, z);
    return Color(_colors[_index(x, y, z)]);
  }

  void setColorRGB(int x, int y, int z, int r, int g, int b) {
    _checkBounds(x, y, z);
    final int argb = (0xFF << 24) | (r << 16) | (g << 8) | b;
    _colors[_index(x, y, z)] = argb;
  }

  void setColor(int x, int y, int z, Color color) {
    _checkBounds(x, y, z);
    _colors[_index(x, y, z)] = color.toARGB32();
  }

  int _index(int x, int y, int z) => z * width * height + y * width + x;

  void _checkBounds(int x, int y, int z) {
    if (x < 0 || x >= width || y < 0 || y >= height || z < 0 || z >= depth) {
      throw RangeError('Coordinates out of bounds: ($x, $y, $z)');
    }
  }
}
