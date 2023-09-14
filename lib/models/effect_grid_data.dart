import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EffectGridData extends Equatable {
  final int sizeX;
  final int sizeY;
  final List<List<Color>> colors;
  final int minSizeX;
  final int minSizeY;

  EffectGridData({
    required this.sizeX,
    required this.sizeY,
    required this.colors,
    required this.minSizeX,
    required this.minSizeY,
  });

  @override
  List<Object> get props => <Object>[];

  factory EffectGridData.initial() {
    return EffectGridData(
      sizeX: 20,
      sizeY: 20,
      colors: <List<Color>>[],
      minSizeX: 20,
      minSizeY: 9,
    );
  }

  factory EffectGridData.fromJson(Map<String, Object?> json) {
    return EffectGridData(
      sizeX: json['sizeX'] as int,
      sizeY: json['sizeY'] as int,
      colors: <List<Color>>[],
      minSizeY: 10,
      minSizeX: 20,
    );
  }

  Map<String, Object?>? toJson() {
    return <String, Object?>{'sizeX': sizeX, 'sizeY': sizeY};
  }

  EffectGridData copyWith({
    final int? sizeX,
    final int? sizeY,
    final List<List<Color>>? colors,
    final int? minSizeX,
    final int? minSizeY,
  }) {
    return EffectGridData(
      sizeX: sizeX ?? this.sizeX,
      sizeY: sizeY ?? this.sizeY,
      colors: colors ?? this.colors,
      minSizeX: minSizeX ?? this.minSizeX,
      minSizeY: minSizeY ?? this.minSizeY,
    );
  }
}
