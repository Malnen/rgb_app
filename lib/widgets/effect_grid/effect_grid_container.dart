import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/lightning_controller_interface.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/extensions/vector_3_extension.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/device_placeholder_data.dart';
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

  @override
  void initState() {
    super.initState();
    effectBloc = GetIt.instance.get();
    devicesBloc = GetIt.instance.get();
  }

  @override
  Widget build(BuildContext context) {
    context.select<DevicesBloc, int>((DevicesBloc bloc) => bloc.state.deviceInstances.length);
    final double margin = cellMargin * 2;
    final double fullHeight = effectBloc.sizeZ * cellSize + effectBloc.sizeZ * margin;
    final double fullWidth = effectBloc.sizeX * cellSize + effectBloc.sizeX * margin;

    return ClipRect(
      child: SizedBox(
        height: fullHeight,
        width: fullWidth,
        child: Stack(
          children: <Widget>[
            EffectGridCells(
              cellMargin: cellMargin,
              cellSize: cellSize,
            ),
            ...devicesBloc.deviceInstances.expand((DeviceInterface deviceInterface) {
              final bool isLightningController = deviceInterface is LightningControllerInterface;
              final List<DeviceInterface> allDevices = <DeviceInterface>[
                if (!isLightningController) deviceInterface,
                if (isLightningController) ...deviceInterface.subDevices,
              ];

              return allDevices.map(
                (DeviceInterface device) => DevicePlaceholder(
                  fullHeight: fullHeight,
                  sizeBase: cellSize + margin,
                  dataNotifier: device.deviceDataNotifier,
                  fullWidth: fullWidth,
                  devicePlaceholderData: DevicePlaceholderData(
                    size: device.getSize(),
                    offset: device.deviceData.offset,
                  ),
                  onUpdateOffset: (double newOffsetX, double newOffsetZ) {
                    devicesBloc.add(
                      UpdateDeviceProperties(
                        offset: device.deviceData.offset.copyWith(x: newOffsetX, z: newOffsetZ),
                        deviceInterface: device,
                      ),
                    );
                  },
                  key: ValueKey<DeviceData>(device.deviceData),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
