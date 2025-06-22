import 'dart:math';

extension DoubleExtension on double {
  double roundToPrecision(int precision) {
    if (precision == 0) {
      return roundToDouble();
    } else {
      final double factor = pow(10, precision).toDouble();
      return (this * factor).roundToDouble() / factor;
    }
  }
}
