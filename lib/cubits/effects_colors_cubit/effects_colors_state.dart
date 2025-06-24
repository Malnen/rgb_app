import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/models/color_list.dart';

part '../../generated/cubits/effects_colors_cubit/effects_colors_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class EffectsColorsState with _$EffectsColorsState {
  @override
  final ColorList colors;
  @override
  final Key key;
  @override
  final Set<int> usedIndexes;

  EffectsColorsState({
    required this.colors,
    required this.key,
    required this.usedIndexes,
  });
}
