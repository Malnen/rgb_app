import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid_cell.dart';

class EffectGridContainer extends StatefulWidget {
  final List<List<Color>> colors;

  const EffectGridContainer({required this.colors});

  @override
  State<EffectGridContainer> createState() => _EffectGridContainerState();
}

class _EffectGridContainerState extends State<EffectGridContainer> {
  late EffectBloc effectBloc;
  late DevicesBloc devicesBloc;
  late List<Effect> effects;
  late StreamController<Object> rebuildNotifier;

  List<List<Color>> get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    effectBloc = context.read();
    devicesBloc = GetIt.instance.get();
    rebuildNotifier = StreamController<Object>.broadcast();

    Timer.periodic(Duration(milliseconds: 25), (final Timer timer) {
      final ColorsUpdatedEvent event = ColorsUpdatedEvent(colors: colors);
      effectBloc.add(event);
      for (final Effect effect in effectBloc.state.effects) {
        effect.update();
      }
      for (final DeviceInterface device in devicesBloc.deviceInstances) {
        device.update();
      }
      rebuildNotifier.add(Object());
    });
  }

  @override
  Widget build(final BuildContext context) {
    return Column(
      children: <Widget>[
        ...List<Widget>.generate(
            effectBloc.sizeY,
            (final int yIndex) => Row(
                  children: <Widget>[
                    ...List<Widget>.generate(
                      effectBloc.sizeX,
                      (final int xIndex) => EffectGridCell(
                        x: xIndex,
                        y: yIndex,
                        bloc: effectBloc,
                        rebuildNotifier: rebuildNotifier,
                      ),
                    )
                  ],
                )),
      ],
    );
  }

  @override
  void dispose() {
    rebuildNotifier.close();
    super.dispose();
  }
}
