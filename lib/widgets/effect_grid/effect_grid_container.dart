import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_effect.dart';
import 'package:rgb_app/effects/rainbow_wave_effect.dart';
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

  List<List<Color>> get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    effectBloc = context.read();
    devicesBloc = GetIt.instance.get();
    effectBloc.add(AddEffectEvent(effect: RainbowWaveEffect()));
    effectBloc.add(AddEffectEvent(effect: KeyStrokeEffect()));

    Timer.periodic(Duration(milliseconds: 25), (Timer timer) {
      final ColorsUpdatedEvent event = ColorsUpdatedEvent(colors: colors);
      effectBloc.add(event);
      for (Effect effect in effectBloc.state.effects) {
        effect.update();
      }
      for (DeviceInterface device in devicesBloc.deviceInstances) {
        device.update();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ...buildRows(),
      ],
    );
  }

  List<Widget> buildRows() {
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < effectBloc.sizeY; i++) {
      final List<Widget> cells = buildCells(i);
      final Widget row = Row(
        children: <Widget>[
          ...cells,
        ],
      );
      rows.add(row);
    }

    return rows;
  }

  List<Widget> buildCells(int i) {
    final List<Widget> cells = <Widget>[];
    for (int j = 0; j < effectBloc.sizeX; j++) {
      final Widget cell = EffectGridCell(
        x: j,
        y: i,
      );
      cells.add(cell);
    }

    return cells;
  }
}
