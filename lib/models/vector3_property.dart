import 'package:rgb_app/json_converters/vector_3_converter.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:vector_math/vector_math.dart';

class Vector3Property extends Property<Vector3> {
  final NumericProperty x;
  final NumericProperty y;
  final NumericProperty z;

  Vector3Property({
    required super.name,
    required super.idn,
    required super.initialValue,
    super.debounceDuration,
    Vector3? min,
    Vector3? max,
    Vector3? precision,
  })  : x = NumericProperty(
          initialValue: initialValue.x,
          name: 'X',
          idn: '${idn}_x',
          min: min?.x ?? 0,
          max: max?.x ?? 1,
          precision: (precision?.x ?? 2).toInt(),
        ),
        y = NumericProperty(
          initialValue: initialValue.y,
          name: 'Y',
          idn: '${idn}_y',
          min: min?.y ?? 0,
          max: max?.y ?? 1,
          precision: (precision?.y ?? 2).toInt(),
        ),
        z = NumericProperty(
          initialValue: initialValue.z,
          name: 'Z',
          idn: '${idn}_z',
          min: min?.z ?? 0,
          max: max?.z ?? 1,
          precision: (precision?.z ?? 2).toInt(),
        ) {
    x.addListener(notifyListeners);
    y.addListener(notifyListeners);
    z.addListener(notifyListeners);
  }

  @override
  Vector3 get value => Vector3(x.value, y.value, z.value);

  @override
  set value(Vector3 newValue) {
    super.value = newValue;
    x.value = newValue.x;
    y.value = newValue.y;
    z.value = newValue.z;
  }

  @override
  void dispose() {
    x.removeListener(notifyListeners);
    y.removeListener(notifyListeners);
    z.removeListener(notifyListeners);
    x.dispose();
    y.dispose();
    z.dispose();
    super.dispose();
  }

  @override
  Map<String, Object> getData() => <String, Object>{
        'value': Vector3Converter().toJson(value),
      };

  @override
  void updateProperty(Vector3Property property) {
    super.updateProperty(property);
    x.updateProperty(property.x);
    y.updateProperty(property.y);
    z.updateProperty(property.z);
  }
}
