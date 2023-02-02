import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_positioned.dart';

class DevicePlaceholder extends StatefulWidget {
  final double fullHeight;
  final double fullWidth;
  final DeviceInterface deviceInterface;
  final double sizeBase;

  const DevicePlaceholder({
    required this.fullHeight,
    required this.fullWidth,
    required this.deviceInterface,
    required this.sizeBase,
  });

  @override
  State<DevicePlaceholder> createState() => _DevicePlaceholderState();
}

class _DevicePlaceholderState extends State<DevicePlaceholder> {
  final GlobalKey key = GlobalKey();

  late Offset? position;
  late DevicesBloc devicesBloc;
  late Vector initialPosition;

  double get fullHeight => widget.fullHeight;

  double get fullWidth => widget.fullWidth;

  DeviceInterface get deviceInterface => widget.deviceInterface;

  double get sizeBase => widget.sizeBase;

  Size get size => deviceInterface.getSize();

  double get width => sizeBase * size.width;

  double get height => sizeBase * size.height;

  int get offsetX => deviceInterface.offsetX;

  int get offsetY => deviceInterface.offsetY;

  @override
  void initState() {
    super.initState();
    devicesBloc = GetIt.instance.get();
    initialPosition = Vector(
      x: offsetX * sizeBase,
      y: offsetY * sizeBase,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          borderRadius: BorderRadius.all(Radius.circular(2)),
          color: Colors.black.withAlpha(200),
        ),
      ),
    );
  }

  void updateOffset(double offsetX, double offsetY) {
    final UpdateDeviceOffsetEvent event = UpdateDeviceOffsetEvent(
      offsetX: offsetX.toInt(),
      offsetY: offsetY.toInt(),
      deviceInterface: deviceInterface,
    );
    devicesBloc.add(event);
  }
}
