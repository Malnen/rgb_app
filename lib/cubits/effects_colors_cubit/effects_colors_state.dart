import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EffectsColorsState extends Equatable {
  final List<List<Color>> colors;
  final Key key;

  EffectsColorsState({required this.colors}) : key = UniqueKey();

  @override
  List<Object> get props => <Object>[
        colors,
        key,
      ];
}
