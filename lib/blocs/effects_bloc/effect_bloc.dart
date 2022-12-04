import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/effects/effect_factory.dart';
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
  }

  @override
  EffectState fromJson(final Map<String, dynamic> json) {
    final List<Map<String, dynamic>> effectsJson = List<Map<String, dynamic>>.from(json['effects'] as List<dynamic>);
    final EffectGridData effectGridData = EffectGridData.fromJson(
      json['effectGridData'] as Map<String, dynamic>,
    );
    final List<Effect> effects = effectsJson.map(EffectFactory.getEffectFromJson).toList();

    return EffectState(
      effectGridData: effectGridData,
      effects: effects,
      availableEffects: EffectDictionary.availableEffects,
    );
  }

  @override
  Map<String, dynamic> toJson(final EffectState state) {
    return <String, dynamic>{
      'effectGridData': state.effectGridData,
      'effects': state.effects.map((final Effect effect) => effect.toJson()).toList(),
    };
  }

  void setBlocInExistingEffects() {
    state.effects.forEach(_setEffectBloc);
  }

  void _setEffectBloc(final Effect effect) => effect.setEffectBloc();

  Future<void> _onSetGridSizeEvent(final SetGridSizeEvent event, final Emitter<EffectState> emit) async {
    final EffectState newState = state.copyWith(
      effectGridData: event.effectGridData,
    );

    emit(newState);
  }

  Future<void> _onColorsUpdatedEvent(final ColorsUpdatedEvent event, final Emitter<EffectState> emit) async {
    final EffectGridData currentData = state.effectGridData;
    final EffectGridData data = currentData.copyWith(colors: event.colors);
    final EffectState newState = state.copyWith(effectGridData: data);

    emit(newState);
  }

  Future<void> _onAddEffectEvent(final AddEffectEvent event, final Emitter<EffectState> emit) async {
    final Effect effect = event.effect;
    final List<Effect> effects = state.effects;
    final bool hasEffect = effects.contains(effect);
    if (!hasEffect) {
      effects.add(effect);
    }

    final EffectState newState = state.copyWith(effects: effects);
    emit(newState);
  }

  Future<void> _onRemoveEffectEvent(final RemoveEffectEvent event, final Emitter<EffectState> emit) async {
    final Effect effect = event.effect;
    final List<Effect> effects = state.effects;
    final bool hasEffect = effects.contains(effect);
    if (hasEffect) {
      effects.remove(effect);
    }

    final EffectState newState = state.copyWith(effects: effects);
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
}
