import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/factories/effect_factory.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

class EffectBloc extends HydratedBloc<EffectEvent, EffectState> {
  List<List<Color>> get colors => state.effectGridData.colors;

  int get sizeX => state.effectGridData.sizeX;

  int get sizeY => state.effectGridData.sizeY;

  EffectBloc() : super(EffectState.initial()) {
    on<SetGridSizeEvent>(_onSetGridSizeEvent);
    on<ColorsUpdatedEvent>(_onColorsUpdatedEvent);
    on<AddEffectEvent>(_onAddEffectEvent);
    on<RemoveEffectEvent>(_onRemoveEffectEvent);
    on<ReorderEffectsEvent>(_onReorderEffectsEvent);
    on<SelectEffectEvent>(_onSelectEffectEvent);
  }

  @override
  EffectState fromJson(Map<String, Object?> json) {
    final List<Map<String, Object?>> effectsJson = List<Map<String, Object?>>.from(json['effects'] as List<Object?>);
    final EffectGridData effectGridData = EffectGridData.fromJson(
      json['effectGridData'] as Map<String, Object?>,
    );
    final List<Effect> effects = effectsJson.map(EffectFactory.getEffectFromJson).toList();

    return EffectState(
      effectGridData: effectGridData,
      effects: effects,
      availableEffects: EffectDictionary.availableEffects,
    );
  }

  @override
  Map<String, Object?> toJson(EffectState state) {
    return <String, Object?>{
      'effectGridData': state.effectGridData,
      'effects': state.effects.map((Effect effect) => effect.toJson()).toList(),
    };
  }

  void setBlocInExistingEffectsAndInit() {
    for (Effect effect in state.effects) {
      effect.setEffectBloc();
      effect.init();
    }
  }

  Future<void> _onSetGridSizeEvent(SetGridSizeEvent event, Emitter<EffectState> emit) async {
    final EffectState newState = state.copyWith(
      effectGridData: event.effectGridData,
      sizeChanged: true,
    );

    emit(newState);
  }

  Future<void> _onColorsUpdatedEvent(ColorsUpdatedEvent event, Emitter<EffectState> emit) async {
    final EffectGridData currentData = state.effectGridData;
    final EffectGridData data = currentData.copyWith(colors: event.colors);
    final EffectState newState = state.copyWith(effectGridData: data);

    emit(newState);
  }

  Future<void> _onAddEffectEvent(AddEffectEvent event, Emitter<EffectState> emit) async {
    final Effect effect = event.effect;
    final List<Effect> effects = state.effects;
    final bool hasEffect = effects.contains(effect);
    if (!hasEffect) {
      effects.add(effect);
    }

    final EffectState newState = state.copyWith(effects: effects);
    emit(newState);
  }

  Future<void> _onRemoveEffectEvent(RemoveEffectEvent event, Emitter<EffectState> emit) async {
    final Effect effect = event.effect;
    final List<Effect> effects = state.effects;
    final bool hasEffect = effects.contains(effect);
    if (hasEffect) {
      effects.remove(effect);
    }

    final EffectState newState = state.copyWith(
      effects: effects,
      clearSelectedEffect: state.selectedEffect == effect,
    );
    emit(newState);
  }

  Future<void> _onReorderEffectsEvent(
    final ReorderEffectsEvent event,
    final Emitter<EffectState> emit,
  ) async {
    final int oldIndex = event.oldIndex;
    final int newIndex = event.newIndex;
    final List<Effect> effects = state.effects;
    final Effect effect = effects.removeAt(oldIndex);
    effects.insert(newIndex, effect);

    final EffectState newState = state.copyWith(
      effects: effects,
    );

    emit(newState);
  }

  Future<void> _onSelectEffectEvent(
    final SelectEffectEvent event,
    final Emitter<EffectState> emit,
  ) async {
    final EffectState newState = state.copyWith(
      selectedEffect: event.effect,
    );
    emit(newState);
  }
}
