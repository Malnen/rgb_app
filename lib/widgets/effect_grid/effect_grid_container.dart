import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_effect.dart';
import 'package:rgb_app/effects/rainbow_wave_effect.dart';
import 'package:rgb_app/models/effect_grid_data.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid_cell.dart';

import '../../blocs/devices_bloc/devices_bloc.dart';
import '../../blocs/effects_bloc/effect_bloc.dart';
import '../../blocs/effects_bloc/effect_state.dart';

class EffectGridContainer extends StatefulWidget {
  @override
  State<EffectGridContainer> createState() => _EffectGridContainerState();
}

class _EffectGridContainerState extends State<EffectGridContainer> {
  late EffectBloc effectBloc;
  late DevicesBloc devicesBloc;
  late EffectGridData effectGridData;
  late List<List<Color>> colors;
  late List<Effect> effects;

  @override
  void initState() {
    super.initState();
    effectBloc = context.read();
    devicesBloc = GetIt.instance.get();
    effectGridData = effectBloc.state.effectGridData;
    effects = <Effect>[
      RainbowWaveEffect(),
      KeyStrokeEffect(),
    ];

    Timer.periodic(Duration(milliseconds: 25), (Timer timer) {
      final ColorsUpdatedEvent event = ColorsUpdatedEvent(colors: colors);
      effectBloc.add(event);
      for (Effect effect in effects) {
        effect.update();
      }
      for (DeviceInterface device in devicesBloc.deviceInstances) {
        device.update();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    colors = buildColors();
    return Column(
      children: <Widget>[
        ...buildRows(),
      ],
    );
  }

  List<List<Color>> buildColors() {
    final List<List<Color>> colors = <List<Color>>[];
    for (int i = 0; i < effectGridData.sizeY; i++) {
      final List<Color> colorRows = buildColorRows();
      colors.add(colorRows);
    }

    return colors;
  }

  List<Color> buildColorRows() {
    final List<Color> colors = <Color>[];
    for (int i = 0; i < effectGridData.sizeX; i++) {
      final Color color = Color.fromARGB(1, 255, 255, 255);
      colors.add(color);
    }

    return colors;
  }

  List<Widget> buildRows() {
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < effectGridData.sizeY; i++) {
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
    for (int j = 0; j < effectGridData.sizeX; j++) {
      final Widget cell = EffectGridCell(
        x: j,
        y: i,
      );
      cells.add(cell);
    }

    return cells;
  }
}
