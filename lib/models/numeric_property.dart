import 'dart:async';

import 'package:rgb_app/enums/numeric_property_type.dart';
import 'package:rgb_app/extensions/double_extension.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/utils/tick_provider.dart';

class NumericProperty extends Property<double> {
  final int _precision;

  double min;
  double max;
  NumericPropertyType propertyType;

  double _rawValue;
  Timer? _debounce;
  bool _debounceEnabled = false;

  static const Duration _debounceDuration = Duration(milliseconds: 4);

  double get invertedValue => (max + 1) - value;

  int get precision => _precision;

  double get adjustedValue => value * TickProvider.fpsMultiplier;

  @override
  double get value => _rawValue;

  @override
  set value(double newValue) {
    final double rounded = newValue.roundToPrecision(_precision).clamp(min, max);
    _rawValue = rounded;

    if (_debounceEnabled) {
      _debounce?.cancel();
      _debounce = Timer(_debounceDuration, _applyDebouncedValue);
    } else {
      _applyDebouncedValue();
    }
  }

  void _applyDebouncedValue() {
    if (super.value != _rawValue) {
      super.value = _rawValue;
    }
  }

  void enableDebounce() {
    _debounceEnabled = true;
  }

  void disableDebounce() {
    _debounceEnabled = false;
  }

  NumericProperty({
    required super.initialValue,
    required super.name,
    required super.idn,
    this.min = 0,
    this.max = 1,
    int precision = 20,
    this.propertyType = NumericPropertyType.slider,
  })  : _precision = precision,
        _rawValue = initialValue;

  @override
  Map<String, Object> getData() => <String, Object>{
        'value': value,
        'propertyType': propertyType.name,
      };

  @override
  void updateProperty(NumericProperty property) {
    super.updateProperty(property);
    propertyType = property.propertyType;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
