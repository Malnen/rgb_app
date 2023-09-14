import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/cell_coords.dart';
import 'package:rgb_app/models/numeric_property.dart';

class SpreadData extends Equatable {
  final CellCoords cellCoords;
  final Color color;
  final bool increment;
  final double opacity;
  final NumericProperty duration;

  SpreadData({
    required this.cellCoords,
    required this.color,
    required this.duration,
    this.increment = true,
    this.opacity = 0,
  });

  SpreadData copyWith({
    final CellCoords? cellCoords,
    final Color? color,
    final NumericProperty? duration,
    final bool? increment,
    final double? opacity,
  }) {
    return SpreadData(
      cellCoords: cellCoords ?? this.cellCoords,
      color: color ?? this.color,
      duration: duration ?? this.duration,
      increment: increment ?? this.increment,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  List<Object> get props => <Object>[
        cellCoords,
        color,
        duration,
        opacity,
        increment,
      ];
}