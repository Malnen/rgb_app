import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_positioned.dart';

class DevicePlaceholder extends HookWidget {
  final double fullHeight;
  final double fullWidth;
  final DeviceInterface deviceInterface;
  final double sizeBase;

  const DevicePlaceholder({
    required this.fullHeight,
    required this.fullWidth,
    required this.deviceInterface,
    required this.sizeBase,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final DevicesBloc devicesBloc = GetIt.instance.get<DevicesBloc>();
    useListenable(deviceInterface.deviceDataNotifier);

    final Size size = deviceInterface.getSize();
    final double width = sizeBase * size.width;
    final double height = sizeBase * size.height;
    final int offsetX = deviceInterface.offsetX;
    final int offsetY = deviceInterface.offsetY;

    final Vector initialPosition = useMemoized(
      () => Vector(x: offsetX * sizeBase, y: offsetY * sizeBase),
      <Object?>[offsetX, offsetY, sizeBase],
    );

    void updateOffset(double newOffsetX, double newOffsetY) {
      final int intX = newOffsetX.toInt();
      final int intY = newOffsetY.toInt();
      if (intX != offsetX || intY != offsetY) {
        devicesBloc.add(
          UpdateDeviceOffsetEvent(
            offsetX: intX,
            offsetY: intY,
            deviceInterface: deviceInterface,
          ),
        );
      }
    }

    return DraggablePositioned(
      width: width,
      height: height,
      fullWidth: fullWidth,
      fullHeight: fullHeight,
      sizeBase: sizeBase,
      snapOnPanEnd: true,
      updateOffset: updateOffset,
      initialPosition: initialPosition,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          color: Colors.black.withAlpha(200),
        ),
      ),
    );
  }
}
