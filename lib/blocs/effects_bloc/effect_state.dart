import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

class EffectState extends Equatable {
  final Key key;
  final EffectGridData effectGridData;
  final List<Effect> effects;
  final List<EffectData> availableEffects;
  final Effect? selectedEffect;

  EffectState({
    required this.effectGridData,
    required this.availableEffects,
    required this.effects,
    this.selectedEffect,
  }) : key = UniqueKey();

  @override
  List<Object?> get props => <Object?>[
        effectGridData,
        availableEffects,
        effects,
        key,
        selectedEffect,
      ];

  factory EffectState.initial() {
    return EffectState(
      effectGridData: EffectGridData.initial(),
      effects: <Effect>[],
      availableEffects: EffectDictionary.availableEffects,
    );
  }

  EffectState copyWith({
    final EffectGridData? effectGridData,
    final List<Effect>? effects,
    final List<EffectData>? availableEffects,
    final Effect? selectedEffect,
  }) {
    return EffectState(
      effectGridData: effectGridData ?? this.effectGridData,
      effects: effects ?? this.effects,
      availableEffects: availableEffects ?? this.availableEffects,
      selectedEffect: selectedEffect ?? this.selectedEffect,
    );
  }

  bool hasEffectGridDataSizeOrMinChanged(final EffectState state) {
    final EffectGridData effectGridData = state.effectGridData;
    final bool hasDifferentSizeX = effectGridData.sizeX != this.effectGridData.sizeX;
    final bool hasDifferentSizeY = effectGridData.sizeY != this.effectGridData.sizeY;
    final bool hasDifferentMinX = effectGridData.minSizeX != this.effectGridData.minSizeX;
    final bool hasDifferentMinY = effectGridData.minSizeY != this.effectGridData.minSizeY;

    return hasDifferentSizeX || hasDifferentSizeY || hasDifferentMinX || hasDifferentMinY;
  }
}
