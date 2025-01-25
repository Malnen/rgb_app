import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

part '../../generated/blocs/effects_bloc/effect_event.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class EffectEvent with _$EffectEvent {
  const factory EffectEvent.setGridSize({
    required EffectGridData effectGridData,
  }) = SetGridSizeEvent;

  const factory EffectEvent.addEffect({
    required Effect effect,
  }) = AddEffectEvent;

  const factory EffectEvent.removeEffect({
    required Effect effect,
  }) = RemoveEffectEvent;

  const factory EffectEvent.reorderEffects({
    required int oldIndex,
    required int newIndex,
  }) = ReorderEffectsEvent;

  const factory EffectEvent.selectEffect({
    required Effect effect,
  }) = SelectEffectEvent;

  const factory EffectEvent.effectPropertyChanged() = EffectPropertyChangedEvent;
}
