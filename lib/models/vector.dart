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
}
