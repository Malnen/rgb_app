import 'package:flutter/foundation.dart';
import 'package:rgb_app/models/property.dart';

class NumericProperty extends Property<double> {
  static const double debugMultiplier = 4;

  final double _min;
  final double _max;
  final bool debugArtificialValue;

  double get invertedValue {
    return (max + 1) - value;
  }

  @override
  double get value => _getCorrectValue(super.value);

  double get currentValue => super.value;

  double get min => _getCorrectValue(_min);

  double get max => _getCorrectValue(_max);

  double _getCorrectValue(double value) => _shouldArtificiallyModifyValues ? value * debugMultiplier : value;

  double _getUnmodifiedValue(double value) => _shouldArtificiallyModifyValues ? value / debugMultiplier : value;

  bool get _shouldArtificiallyModifyValues => debugArtificialValue && kDebugMode;

  NumericProperty({
    required super.initialValue,
    required super.name,
    required double min,
    required double max,
    this.debugArtificialValue = false,
  })  : _min = min,
        _max = max;

  @override
  Map<String, Object> getData() {
    return <String, Object>{
      'min': _getUnmodifiedValue(min),
      'max': _getUnmodifiedValue(max),
      'value': _getUnmodifiedValue(value),
      'debugArtificialValue': debugArtificialValue,
    };
  }

  NumericProperty copyWith({
    final double? initialValue,
    final String? name,
    final double? min,
    final double? max,
  }) {
    return NumericProperty(
      initialValue: initialValue ?? value,
      name: name ?? this.name,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }
}
