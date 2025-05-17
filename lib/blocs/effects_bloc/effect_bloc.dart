import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/utils/tick_provider.dart';

class EffectBloc extends HydratedBloc<EffectEvent, EffectState> {
  final TickProvider _tickProvider;

  int get sizeX => state.effectGridData.sizeX;

  int get sizeY => state.effectGridData.sizeY;

  EffectBloc({required TickProvider tickProvider})
      : _tickProvider = tickProvider,
        super(EffectState.initial()) {
    on<SetGridSizeEvent>(_onSetGridSizeEvent);
    on<AddEffectEvent>(_onAddEffectEvent);
    on<RemoveEffectEvent>(_onRemoveEffectEvent);
    on<ReorderEffectsEvent>(_onReorderEffectsEvent);
    on<SelectEffectEvent>(_onSelectEffectEvent);
    on<EffectPropertyChangedEvent>(_onEffectPropertyChangedEvent);
    _tickProvider.onTick(() async {
      for (Effect effect in state.effects) {
        try {
          effect.update();
        } catch (error) {
          print(error);
        }
      }
    });
  }

  @override
  EffectState fromJson(Map<String, Object?> json) => EffectState.fromJson(json);

  @override
  Map<String, Object?> toJson(EffectState state) {
    return state.toJson();
  }

  Future<void> _onSetGridSizeEvent(SetGridSizeEvent event, Emitter<EffectState> emit) async {
    final EffectState newState = state.copyWith(
      effectGridData: event.effectGridData,
      sizeChanged: true,
      key: UniqueKey(),
    );

    emit(newState);
  }

  Future<void> _onAddEffectEvent(AddEffectEvent event, Emitter<EffectState> emit) async {
    final Effect effect = event.effect;
    final List<Effect> effects = state.effects;
    final bool hasEffect = effects.contains(effect);
    if (!hasEffect) {
      effects.add(effect);
    }

    final EffectState newState = state.copyWith(
      effects: effects,
      key: UniqueKey(),
    );
    emit(newState);
  }

  Future<void> _onRemoveEffectEvent(RemoveEffectEvent event, Emitter<EffectState> emit) async {
    final Effect effect = event.effect;
    final List<Effect> effects = state.effects;
    final bool hasEffect = effects.contains(effect);
    if (hasEffect) {
      effect.dispose();
      effects.remove(effect);
    }

    final bool clearSelectedEffect = state.selectedEffect == effect;
    final Effect? selectedEffectValue = clearSelectedEffect ? null : state.selectedEffect;
    final EffectState newState = state.copyWith(
      effects: effects,
      selectedEffect: selectedEffectValue,
      key: UniqueKey(),
    );
    emit(newState);
  }

  Future<void> _onReorderEffectsEvent(
    final ReorderEffectsEvent event,
    final Emitter<EffectState> emit,
  ) async {
    final int oldIndex = event.oldIndex;
    final int newIndex = event.newIndex;
    final List<Effect> effects = <Effect>[...state.effects];
    final Effect effect = effects.removeAt(oldIndex);
    effects.insert(newIndex, effect);

    final EffectState newState = state.copyWith(
      effects: effects,
      key: UniqueKey(),
    );

    emit(newState);
  }

  Future<void> _onSelectEffectEvent(
    final SelectEffectEvent event,
    final Emitter<EffectState> emit,
  ) async {
    final EffectState newState = state.copyWith(
      selectedEffect: event.effect,
      key: UniqueKey(),
    );
    emit(newState);
    final ValueNotifier<Object?> rightPanelSelectionNotifier =
        GetIt.instance.get(instanceName: 'rightPanelSelectionNotifier');
    rightPanelSelectionNotifier.value = event.effect;
  }

  Future<void> _onEffectPropertyChangedEvent(
    final EffectPropertyChangedEvent event,
    final Emitter<EffectState> emit,
  ) async {
    final EffectState newState = state.copyWith(key: UniqueKey());
    emit(newState);
  }
}
