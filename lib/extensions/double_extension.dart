extension DoubleExtension on double {
  double roundToPrecision(int precision) {
    if (precision == 0) {
      return toInt().toDouble();
    } else if (this != 0) {
      final int factor = 10.toInt() ^ precision;
      return (this * factor).roundToDouble() / factor;
    }

    return this;
  }
}
