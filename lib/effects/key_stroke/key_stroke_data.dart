import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/cell_coords.dart';

class KeyStrokeData extends Equatable {
  final CellCoords cellCoords;
  final Color color;
  final double duration;
  final bool increment;
  final double opacity;

  KeyStrokeData({
    required this.cellCoords,
    required this.color,
    required this.duration,
    this.increment = true,
    this.opacity = 0,
  });

  KeyStrokeData copyWith({
    CellCoords? cellCoords,
    Color? color,
    double? duration,
    bool? increment,
    double? opacity,
  }) {
    return KeyStrokeData(
      cellCoords: cellCoords ?? this.cellCoords,
      color: color ?? this.color,
      duration: duration ?? this.duration,
      increment: increment ?? this.increment,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  List<Object?> get props => [
        cellCoords,
        color,
        duration,
        opacity,
        increment,
      ];
}
