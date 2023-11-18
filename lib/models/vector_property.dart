import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/vector.dart';

class VectorProperty extends Property<Vector> {
  VectorProperty({
    required super.name,
    required super.idn,
    required super.initialValue,
  });

  @override
  Map<String, Object> getData() {
    return <String, Object>{
      'value': value.toJson(),
    };
  }

  VectorProperty copyWith({
    final Vector? initialValue,
    final String? idn,
    final String? name,
  }) {
    return VectorProperty(
      initialValue: initialValue ?? value,
      name: name ?? this.name,
      idn: idn ?? this.idn,
    );
  }
}
