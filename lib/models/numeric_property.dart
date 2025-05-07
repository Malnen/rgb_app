import 'package:rgb_app/enums/numeric_property_type.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/utils/tick_provider.dart';

class NumericProperty extends Property<double> {
  double _min;
  double _max;
  NumericPropertyType propertyType;

  double get invertedValue {
    return (max + 1) - value;
  }

  double get min => _min;

  double get max => _max;

  double get adjustedValue => value * TickProvider.fpsMultiplier;

  NumericProperty({
    required super.initialValue,
    required super.name,
    required super.idn,
    required double min,
    required double max,
    this.propertyType = NumericPropertyType.slider,
  })  : _min = min,
        _max = max;

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
    _min = property.min;
    _max = property.max;
    value = property.value;
    propertyType = property.propertyType;
  }
}
