import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/widgets/effect_property_renderer/effect_property_renderer.dart';

class EffectConfigurator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Effect? currentEffect = context.select<EffectBloc, Effect?>((EffectBloc bloc) => bloc.state.selectedEffect);
    return Column(
      children: <Widget>[
        ..._getProperties(currentEffect),
      ],
    );
  }

  List<Widget> _getProperties(Effect? currentEffect) {
    if (currentEffect != null) {
      return currentEffect.properties
          .map(
            (Property<Object> property) => EffectPropertyRenderer(
              property: property,
            ),
          )
          .toList();
    }

    return <Widget>[];
  }
}
