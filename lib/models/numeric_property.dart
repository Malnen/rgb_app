import 'package:flutter/foundation.dart';
import 'package:rgb_app/enums/numeric_property_type.dart';
import 'package:rgb_app/models/property.dart';

class NumericProperty extends Property<double> {
  static const double debugMultiplier = 4;

  double _min;
  double _max;
  bool debugArtificialValue;
  NumericPropertyType propertyType;

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
    required super.idn,
    required double min,
    required double max,
    this.debugArtificialValue = false,
    this.propertyType = NumericPropertyType.slider,
  })  : _min = min,
        _max = max;

  @override
  Map<String, Object> getData() => <String, Object>{
        'min': _getUnmodifiedValue(min),
      'max': _getUnmodifiedValue(max),
      'value': _getUnmodifiedValue(value),
      'debugArtificialValue': debugArtificialValue,
      'propertyType': propertyType.name,
    };

  @override
  void updateProperty(NumericProperty property) {
    super.updateProperty(property);
    _min = _getUnmodifiedValue(property.min);
    _max = _getUnmodifiedValue(property.max);
    value = _getUnmodifiedValue(property.value);
    debugArtificialValue = property.debugArtificialValue;
    propertyType = property.propertyType;
  }
}
