import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/widgets/device_placeholder/device_placeholder.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid_cells.dart';

class EffectGridContainer extends StatefulWidget {
  const EffectGridContainer();

  @override
  State<EffectGridContainer> createState() => _EffectGridContainerState();
}

class _EffectGridContainerState extends State<EffectGridContainer> {
  final double cellSize = 20;
  final double cellMargin = 2;

  late EffectBloc effectBloc;
  late DevicesBloc devicesBloc;
  late List<Effect> effects;
  late GlobalKey cellsKey;

  @override
  void initState() {
    super.initState();
    effectBloc = GetIt.instance.get();
    devicesBloc = GetIt.instance.get();
    cellsKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    context.select<DevicesBloc, int>((DevicesBloc bloc) => bloc.state.deviceInstances.length);
    final double margin = cellMargin * 2;
    final double fullHeight = effectBloc.sizeY * cellSize + effectBloc.sizeY * margin;
    final double fullWidth = effectBloc.sizeX * cellSize + effectBloc.sizeX * margin;

    return SizedBox(
      height: fullHeight,
      width: fullWidth,
      child: Stack(
        children: <Widget>[
          EffectGridCells(
            cellMargin: cellMargin,
            cellSize: cellSize,
          ),
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

  @override
  void dispose() {
    super.dispose();
  }
}
