import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/vector.dart';

class VectorProperty extends Property<Vector> {
  VectorProperty({
    required super.name,
    required super.idn,
    required super.initialValue,
  });

  @override
  Map<String, Object> getData() => <String, Object>{
        'value': value.toJson(),
      };
}
