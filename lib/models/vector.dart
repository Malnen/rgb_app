import 'package:equatable/equatable.dart';

class Vector extends Equatable {
  final double x;
  final double y;

  Vector({
    required this.x,
    required this.y,
  });

  @override
  List<Object> get props => <Object>[
        x,
        y,
      ];

  Map<String, Object> toJson() {
    return <String, Object>{
      'x': x,
      'y': y,
    };
  }

  factory Vector.fromJson(Map<String, Object> json) {
    final double x = json['x'] as double;
    final double y = json['y'] as double;

    return Vector(x: x, y: y);
  }
}
