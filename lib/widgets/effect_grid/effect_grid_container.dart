import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/widgets/device_placeholder/device_placeholder.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid_cell.dart';

class EffectGridContainer extends StatefulWidget {
  final List<List<Color>> colors;

  const EffectGridContainer({required this.colors});

  @override
  State<EffectGridContainer> createState() => _EffectGridContainerState();
}

class _EffectGridContainerState extends State<EffectGridContainer> {
  final double cellSize = 20;
  final double cellMargin = 2;

  late EffectBloc effectBloc;
  late DevicesBloc devicesBloc;
  late List<Effect> effects;
  late StreamController<Object> rebuildNotifier;

  List<List<Color>> get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    effectBloc = context.read();
    devicesBloc = context.read();
    rebuildNotifier = StreamController<Object>.broadcast();

    Timer.periodic(Duration(milliseconds: 25), (Timer timer) {
      final ColorsUpdatedEvent event = ColorsUpdatedEvent(colors: colors);
      effectBloc.add(event);
      for (Effect effect in effectBloc.state.effects) {
        effect.update();
      }
      for (DeviceInterface device in devicesBloc.deviceInstances) {
        device.update();
      }
      rebuildNotifier.add(Object());
    });
  }

  @override
  Widget build(BuildContext context) {
    context.select<DevicesBloc, int>((DevicesBloc bloc) => bloc.state.deviceInstances.length);

    final Widget grid = buildGrid();
    final double margin = cellMargin * 2;
    final double fullHeight = effectBloc.sizeY * cellSize + effectBloc.sizeY * margin;
    final double fullWidth = effectBloc.sizeX * cellSize + effectBloc.sizeX * margin;

    return SizedBox(
      height: fullHeight,
      width: fullWidth,
      child: Stack(
        children: <Widget>[
          grid,
          ...devicesBloc.deviceInstances.map(
            (DeviceInterface deviceInterface) => DevicePlaceholder(
              fullHeight: fullHeight,
              sizeBase: cellSize + margin,
              fullWidth: fullWidth,
              deviceInterface: deviceInterface,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGrid() {
    return Column(
      children: <Widget>[
        ...List<Widget>.generate(
          effectBloc.sizeY,
              (int yIndex) => Row(
            children: <Widget>[
              ...List<Widget>.generate(
                effectBloc.sizeX,
                (int xIndex) => EffectGridCell(
                  margin: cellMargin,
                  size: cellSize,
                  x: xIndex,
                  y: yIndex,
                  bloc: effectBloc,
                  rebuildNotifier: rebuildNotifier,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    rebuildNotifier.close();
    super.dispose();
  }
}
