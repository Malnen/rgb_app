import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/effects/effect_factory.dart';
import 'package:rgb_app/widgets/left_panel/generic_list_container/generic_list_container.dart';

class EffectsListContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.select<EffectBloc, int>((EffectBloc effectBloc) => effectBloc.state.effects.length);
    context.select<EffectBloc, int>((EffectBloc effectBloc) => effectBloc.state.availableEffects.length);

    final EffectBloc effectBloc = context.read();
    final EffectState state = effectBloc.state;

    return GenericListContainer<EffectData>(
      dialogLabel: 'Choose effect',
      getIcon: (EffectData effectData) => effectData.iconData,
      onAdd: (EffectData effectData) => _onAdd(effectBloc, effectData),
      onReorder: (List<EffectData> values) {},
      availableValues: EffectDictionary.availableEffects,
      getName: (EffectData effectData) => effectData.name,
      onRemove: (EffectData effectData) => _onRemove(effectBloc, effectData),
      values: state.effects.map((Effect effect) => effect.effectData).toList(),
    );
  }

  void _onRemove(EffectBloc bloc, EffectData effectData) {
    final EffectState state = bloc.state;
    final List<Effect> effects = state.effects;
    final Effect? effect = effects.firstWhereOrNull((element) => element.effectData == effectData);
    if (effect != null) {
      final RemoveEffectEvent event = RemoveEffectEvent(effect: effect);
      bloc.add(event);
    }
  }

  void _onAdd(EffectBloc bloc, EffectData effectData) {
    final String className = effectData.className;
    final Effect effect = EffectFactory.getEffectByClassName(className);
    effect.setEffectBloc();

    final AddEffectEvent event = AddEffectEvent(effect: effect);
    bloc.add(event);
  }
}
