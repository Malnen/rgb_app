import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

abstract class EffectEvent extends Equatable {}

class SetGridSizeEvent extends EffectEvent {
  final EffectGridData effectGridData;

  SetGridSizeEvent({required this.effectGridData});

  @override
  List<Object> get props => <Object>[effectGridData];
}

class ColorsUpdatedEvent extends EffectEvent {
  final Key key;
  final List<List<Color>> colors;

  ColorsUpdatedEvent({required this.colors}) : key = UniqueKey();

  @override
  List<Object> get props => <Object>[
        colors,
        key,
      ];
}
