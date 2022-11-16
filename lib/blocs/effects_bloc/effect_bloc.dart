import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

class EffectBloc extends HydratedBloc<EffectEvent, EffectState> {
  List<List<Color>> get colors => state.effectGridData.colors;

  int get sizeX => state.effectGridData.sizeX;

  int get sizeY => state.effectGridData.sizeY;

  EffectBloc() : super(EffectState.initial()) {
    on<SetGridSizeEvent>(_onSetGridSizeEvent);
    on<ColorsUpdatedEvent>(_onColorsUpdatedEvent);
  }

  @override
  EffectState fromJson(Map<String, dynamic> json) {
    return EffectState(
      effectGridData: EffectGridData.fromJson(
        json['effectGridData'] as Map<String, dynamic>,
      ),
      forceUpdate: false,
    );
  }

  @override
  Map<String, dynamic> toJson(EffectState state) {
    return {
      'effectGridData': state.effectGridData,
    };
  }

  Future<void> _onSetGridSizeEvent(SetGridSizeEvent event, Emitter<EffectState> emit) async {
    final EffectState newState = state.copyWith(
      effectGridData: event.effectGridData,
      forceUpdate: true,
    );

    emit(newState);
  }

  Future<void> _onColorsUpdatedEvent(ColorsUpdatedEvent event, Emitter<EffectState> emit) async {
    final EffectGridData currentData = state.effectGridData;
    final EffectGridData data = currentData.copyWith(colors: event.colors);
    final EffectState newState = state.copyWith(effectGridData: data);

    emit(newState);
  }
}
