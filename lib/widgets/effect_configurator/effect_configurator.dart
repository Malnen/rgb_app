import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/widgets/property_renderer/property_renderer.dart';

class EffectConfigurator extends StatefulWidget {
  @override
  State<EffectConfigurator> createState() => _EffectConfiguratorState();
}

class _EffectConfiguratorState extends State<EffectConfigurator> {
  @override
  Widget build(BuildContext context) {
    final Effect? currentEffect = context.select<EffectBloc, Effect?>((EffectBloc bloc) => bloc.state.selectedEffect);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      children: _getProperties(currentEffect),
    );
  }

  List<Widget> _getProperties(Effect? currentEffect) {
    if (currentEffect != null) {
      return currentEffect.properties
          .where((Property<Object> property) => property.visible)
          .map(
            (Property<Object> property) => PropertyRenderer(
              property: property,
              updateRenderer: () => setState(() {}),
            ),
          )
          .toList();
    }

    return <Widget>[];
  }
}
