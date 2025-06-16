import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/json_converters/effect_converter.dart';
import 'package:rgb_app/json_converters/unique_key_converter.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

part '../../generated/blocs/effects_bloc/effect_state.freezed.dart';
part '../../generated/blocs/effects_bloc/effect_state.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class EffectState with _$EffectState {
  @override
  final EffectGridData effectGridData;

  @override
  @EffectConverter()
  final List<Effect> effects;

  @override
  @UniqueKeyConverter()
  final UniqueKey key;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<EffectData> availableEffects;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Effect? selectedEffect;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final bool sizeChanged;

  EffectState({
    required this.effectGridData,
    required this.effects,
    required this.key,
    this.selectedEffect,
    this.availableEffects = const <EffectData>[],
    this.sizeChanged = false,
  });

  factory EffectState.initial() => EffectState(
        effectGridData: EffectGridData.initial(),
        effects: <Effect>[],
        availableEffects: EffectDictionary.availableEffects,
        key: UniqueKey(),
      );

  factory EffectState.fromJson(Map<String, Object?> json) => _$EffectStateFromJson(json);

  Map<String, Object?> toJson() => _$EffectStateToJson(this);

  bool hasEffectGridDataSizeOrMinChanged(EffectState state) {
    final EffectGridData effectGridData = state.effectGridData;
    final bool hasDifferentSizeX = effectGridData.sizeX != this.effectGridData.sizeX;
    final bool hasDifferentSizeZ = effectGridData.sizeZ != this.effectGridData.sizeZ;
    final bool hasDifferentMinX = effectGridData.minSizeX != this.effectGridData.minSizeX;
    final bool hasDifferentMinZ = effectGridData.minSizeZ != this.effectGridData.minSizeZ;

    return hasDifferentSizeX || hasDifferentSizeZ || hasDifferentMinX || hasDifferentMinZ;
  }
}
