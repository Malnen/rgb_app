import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/devices/device_interface.dart';

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

  double left = 0;
  double top = 0;

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
    left = sizeBase * offsetX;
    top = sizeBase * offsetY;
  }

  @override
  Widget build(final BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: Container(
          width: width,
          height: height,
          color: Colors.black.withAlpha(200),
        ),
      ),
    );
  }

  void onPanUpdate(final DragUpdateDetails details) {
    left = getLeft(details);
    top = getTop(details);
    final int offsetX = left ~/ sizeBase;
    final int offsetY = top ~/ sizeBase;
    updateOffset(
      offsetX: offsetX,
      offsetY: offsetY,
    );
    setState(() {});
  }

  void onPanEnd(final DragEndDetails details) {
    left = offsetX * sizeBase;
    top = offsetY * sizeBase;
    setState(() {});
  }

  double getLeft(final DragUpdateDetails details) {
    final Offset delta = details.delta;
    final double dx = delta.dx;
    final double newLeft = left + dx;
    if (newLeft < 0) {
      return 0;
    } else if (newLeft + width > fullWidth) {
      return fullWidth - width;
    }

    return newLeft;
  }

  double getTop(final DragUpdateDetails details) {
    final Offset delta = details.delta;
    final double dy = delta.dy;
    final double newTop = top + dy;
    if (newTop < 0) {
      return 0;
    } else if (newTop + height > fullHeight) {
      return fullHeight - height;
    }

    return newTop;
  }

  void updateOffset({
    required final int offsetX,
    required final int offsetY,
  }) {
    final UpdateDeviceOffsetEvent event = UpdateDeviceOffsetEvent(
      offsetX: offsetX,
      offsetY: offsetY,
      deviceInterface: deviceInterface,
    );
    devicesBloc.add(event);
  }
}
