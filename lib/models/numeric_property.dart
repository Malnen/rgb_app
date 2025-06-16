import 'package:rgb_app/enums/numeric_property_type.dart';
import 'package:rgb_app/extensions/double_extension.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/utils/tick_provider.dart';

class NumericProperty extends Property<double> {
  double min;
  double max;
  int _precision;
  NumericPropertyType propertyType;

  double get invertedValue {
    return (max + 1) - value;
  }

  double get adjustedValue => value * TickProvider.fpsMultiplier;

  @override
  set value(double value) {
    final double roundToPrecision = value.roundToPrecision(_precision);
    if (roundToPrecision > max) {
      super.value = max;
    } else if (roundToPrecision < min) {
      super.value = min;
    } else {
      super.value = roundToPrecision;
    }
  }

  NumericProperty({
    required super.initialValue,
    required super.name,
    required super.idn,
    required this.min,
    required this.max,
    int precision = 20,
    this.propertyType = NumericPropertyType.slider,
  }) : _precision = precision;

  @override
  Map<String, Object> getData() => <String, Object>{
        'min': min,
        'max': max,
        'value': value,
        'propertyType': propertyType.name,
      };

  @override
  void updateProperty(NumericProperty property) {
    super.updateProperty(property);
    min = property.min;
    max = property.max;
    value = property.value;
    propertyType = property.propertyType;
    _precision = property._precision;
  }
}
