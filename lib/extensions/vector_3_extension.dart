import 'package:vector_math/vector_math.dart';

extension Vector3Extension on Vector3 {
  Vector3 copyWith({double? x, double? y, double? z}) => Vector3(
        x ?? this.x,
        y ?? this.y,
        z ?? this.z,
      );
}
