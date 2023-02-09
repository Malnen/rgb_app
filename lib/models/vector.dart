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

  Vector withPadding(double padding) {
    return Vector(
      x: x + padding,
      y: y + padding,
    );
  }

  Vector copyWith({
    double? x,
    double? y,
  }) {
    return Vector(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  factory Vector.fromJson(Map<String, Object> json) {
    final double x = json['x'] as double;
    final double y = json['y'] as double;

    return Vector(x: x, y: y);
  }
}
