import 'package:json_annotation/json_annotation.dart';
import 'package:vector_math/vector_math.dart';

class Vector3Converter implements JsonConverter<Vector3, Map<String, Object?>> {
  const Vector3Converter();

  @override
  Vector3 fromJson(Map<String, Object?> json) => Vector3(
        json['x'] as double,
        json['y'] as double,
        json['z'] as double,
      );

  @override
  Map<String, Object?> toJson(Vector3 object) => <String, Object?>{
        'x': object.x,
        'y': object.y,
        'z': object.z,
      };
}
