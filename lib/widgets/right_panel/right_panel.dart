import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/widgets/3d_view/view_3d.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid_size_fields.dart';
import 'package:rgb_app/widgets/right_panel/right_panel_details.dart';

class RightPanel extends HookWidget {
  const RightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> showEffects = useValueNotifier(false);

    return MultiBlocProvider(
      providers: <BlocProvider<BlocBase<Object>>>[
        BlocProvider<EffectBloc>.value(value: GetIt.instance.get()),
        BlocProvider<EffectsColorsCubit>.value(value: GetIt.instance.get()),
        BlocProvider<DevicesBloc>.value(value: GetIt.instance.get()),
      ],
      child: Flexible(
        child: Container(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          child: ListView(
            controller: ScrollController(),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  EffectGrid(),
                  Container(
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: <Widget>[
                        View3D(
                          width: 1200,
                          height: 600,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
                          showEffects: showEffects,
                        ),
                        Positioned(
                          right: 0,
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Show Effects ',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              ValueListenableBuilder<bool>(
                                valueListenable: showEffects,
                                builder: (BuildContext context, bool value, Widget? child) => Switch(
                                  value: value,
                                  onChanged: (bool value) => showEffects.value = value,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  RightPanelDetails(),
                  SizedBox(height: 100),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
