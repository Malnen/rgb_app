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

  Vector({
    required this.x,
    required this.y,
  });

  factory Vector.fromJson(Map<String, Object?> json) => _$VectorFromJson(json);

  Map<String, Object?> toJson() => _$VectorToJson(this);

  Vector withPadding(double padding) {
    return Vector(
      x: x + padding,
      y: y + padding,
    );
  }
}
