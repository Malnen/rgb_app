import 'package:equatable/equatable.dart';

class CellCoords extends Equatable {
  final int x;
  final int y;

  CellCoords({
    required this.x,
    required this.y,
  });

  CellCoords getWithOffset({final int offsetX = 0, final int offsetY = 0}) {
    return CellCoords(
      x: x + offsetX,
      y: y + offsetY,
    );
  }

  factory CellCoords.notFound() {
    return CellCoords(x: -1, y: -1);
  }

  @override
  List<Object> get props => <Object>[
        x,
        y,
      ];
}
