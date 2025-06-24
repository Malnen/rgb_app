import 'package:rgb_app/enums/numeric_property_type.dart';
import 'package:rgb_app/extensions/double_extension.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/utils/tick_provider.dart';

class NumericProperty extends Property<double> {
  final int _precision;

  double min;
  double max;
  NumericPropertyType propertyType;

  double get invertedValue => (max + 1) - value;

  int get precision => _precision;

  double get adjustedValue => value * TickProvider.fpsMultiplier;

  @override
  set value(double newValue) {
    final double rounded = newValue.roundToPrecision(_precision).clamp(min, max);
    super.value = rounded;
  }

  NumericProperty({
    required super.initialValue,
    required super.name,
    required super.idn,
    this.min = 0,
    this.max = 1,
    int precision = 20,
    this.propertyType = NumericPropertyType.slider,
  }) : _precision = precision;

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
}
