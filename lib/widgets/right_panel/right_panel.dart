import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/widgets/effect_configurator/effect_configurator.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid.dart';

class RightPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object>>>[
        BlocProvider<EffectBloc>.value(
          value: GetIt.instance.get(),
        ),
        BlocProvider<EffectsColorsCubit>.value(
          value: GetIt.instance.get(),
        ),
        BlocProvider<DevicesBloc>.value(
          value: GetIt.instance.get(),
        ),
      ],
      child: _body(),
    );
  }

  Flexible _body() {
    return Flexible(
      child: ListView(
        controller: ScrollController(),
        children: <Widget>[
          Column(
            children: <Widget>[
              EffectGrid(),
              EffectConfigurator(),
            ],
          ),
        ],
      ),
    );
  }
}
