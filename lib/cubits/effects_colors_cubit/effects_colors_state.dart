import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class EffectsColorsState extends Equatable {
  final List<List<Color>> colors;

  EffectsColorsState({required this.colors});

  @override
  List<Object> get props => <Object>[colors];
}
