import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/vector.freezed.dart';
part '../generated/models/vector.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class Vector with _$Vector {
  @override
  final double x;
  @override
  final double y;
  @override
  final double z;

  Vector({
    this.x = 0,
    this.y = 0,
    this.z = 0,
  });

  factory Vector.fromJson(Map<String, Object?> json) => _$VectorFromJson(json);

  Map<String, Object?> toJson() => _$VectorToJson(this);

  Vector withPadding(double padding) {
    return Vector(
      x: x + padding,
      y: y + padding,
      z: z + padding,
    );
  }
}
