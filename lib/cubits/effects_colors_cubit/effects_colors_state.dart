import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/cubits/effects_colors_cubit/effects_colors_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class EffectsColorsState with _$EffectsColorsState {
  const factory EffectsColorsState({
    required List<List<Color>> colors,
    required Key key,
  }) = _EffectsColorsState;

  factory EffectsColorsState.withRandomKey({
    required List<List<Color>> colors,
  }) =>
      EffectsColorsState(
        colors: colors,
        key: UniqueKey(),
      );
}
