import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/vector.dart';

class VectorProperty extends Property<Vector> {
  VectorProperty({
    required super.value,
    required super.name,
    super.onChanged,
  });

  @override
  Map<String, Object> getData() {
    return <String, Object>{
      'value': value.toJson(),
    };
  }

  VectorProperty copyWith({
    final Vector? value,
    final String? name,
  }) {
    return VectorProperty(
      value: value ?? this.value,
      name: name ?? this.name,
    );
  }
}
