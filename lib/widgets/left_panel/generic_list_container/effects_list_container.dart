import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/factories/effect_factory.dart';
import 'package:rgb_app/widgets/left_panel/generic_list_container/generic_list_container.dart';

class EffectsListContainer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final EffectBloc effectBloc = GetIt.instance.get();
    final EffectState state = useBlocBuilder(effectBloc);

    return GenericListContainer<EffectData>(
      dialogLabel: 'Choose effect',
      isDisabled: (_) => false,
      getIcon: (EffectData effectData) => effectData.iconData,
      onAdd: (EffectData effectData) => _onAdd(effectBloc, effectData),
      onTap: (EffectData effectData) => _onSelect(effectBloc, effectData),
      onReorder: (int oldIndex, int newIndex) => _onReorder(effectBloc, oldIndex, newIndex),
      availableValues: EffectDictionary.availableEffects,
      getName: (EffectData effectData) => effectData.name,
      onRemove: (EffectData effectData) => _onRemove(effectBloc, effectData),
      values: state.effects.map((Effect effect) => effect.effectData).toList(),
    );
  }

  void _onRemove(EffectBloc bloc, EffectData effectData) {
    final EffectState state = bloc.state;
    final List<Effect> effects = state.effects;
    final Effect? effect = effects.firstWhereOrNull((Effect element) => element.effectData == effectData);
    if (effect != null) {
      final RemoveEffectEvent event = RemoveEffectEvent(effect: effect);
      bloc.add(event);
    }
  }

  void _onAdd(EffectBloc bloc, EffectData effectData) {
    final String className = effectData.className;
    final Effect effect = EffectFactory.getEffectByClassName(className);
    final AddEffectEvent event = AddEffectEvent(effect: effect);
    bloc.add(event);
  }

  void _onSelect(EffectBloc bloc, EffectData effectData) {
    final EffectState state = bloc.state;
    final List<Effect> effects = state.effects;
    final Effect effect = effects.firstWhere((Effect element) => element.effectData == effectData);
    final EffectEvent event = EffectEvent.selectEffect(effect: effect);

    bloc.add(event);
  }

  void _onReorder(EffectBloc effectBloc, int oldIndex, int newIndex) {
    final ReorderEffectsEvent reorderEffects = ReorderEffectsEvent(oldIndex: oldIndex, newIndex: newIndex);
    effectBloc.add(reorderEffects);
  }
}
