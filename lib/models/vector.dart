import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/vector.freezed.dart';
part '../generated/models/vector.g.dart';

@freezed
class Vector with _$Vector {
  Vector._();

  factory Vector({
    required double x,
    required double y,
  }) = _Vector;

  factory Vector.fromJson(Map<String, Object?> json) => _$VectorFromJson(json);

  Vector withPadding(double padding) {
    return Vector(
      x: x + padding,
      y: y + padding,
    );
  }
}
