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

class EffectsListContainer extends StatefulWidget {
  @override
  State<EffectsListContainer> createState() => _EffectsListContainerState();
}

class _EffectsListContainerState extends State<EffectsListContainer> {
  @override
  Widget build(final BuildContext context) {
    context.select<EffectBloc, int>((final EffectBloc effectBloc) => effectBloc.state.effects.length);
    context.select<EffectBloc, int>((final EffectBloc effectBloc) => effectBloc.state.availableEffects.length);

    final EffectBloc effectBloc = context.read();
    final EffectState state = effectBloc.state;

    return GenericListContainer<EffectData>(
      dialogLabel: 'Choose effect',
      isDisabled: (final _) => false,
      getIcon: (final EffectData effectData) => effectData.iconData,
      onAdd: (final EffectData effectData) => _onAdd(effectBloc, effectData),
      onReorder: (final int oldIndex, final int newIndex) => _onReorder(effectBloc, oldIndex, newIndex),
      availableValues: EffectDictionary.availableEffects,
      getName: (final EffectData effectData) => effectData.name,
      onRemove: (final EffectData effectData) => _onRemove(effectBloc, effectData),
      values: state.effects.map((final Effect effect) => effect.effectData).toList(),
    );
  }

  void _onRemove(final EffectBloc bloc, final EffectData effectData) {
    final EffectState state = bloc.state;
    final List<Effect> effects = state.effects;
    final Effect? effect = effects.firstWhereOrNull((final Effect element) => element.effectData == effectData);
    if (effect != null) {
      final RemoveEffectEvent event = RemoveEffectEvent(effect: effect);
      bloc.add(event);
    }
  }

  void _onAdd(final EffectBloc bloc, final EffectData effectData) {
    final String className = effectData.className;
    final Effect effect = EffectFactory.getEffectByClassName(className);
    effect.setEffectBloc();

    final AddEffectEvent event = AddEffectEvent(effect: effect);
    bloc.add(event);
  }

  void _onReorder(final EffectBloc effectBloc, final int oldIndex, final int newIndex) {
    setState(() {
      final ReorderEffectsEvent reorderEffects = ReorderEffectsEvent(oldIndex: oldIndex, newIndex: newIndex);
      effectBloc.add(reorderEffects);
    });
  }
}
