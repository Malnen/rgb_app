import 'package:flutter/material.dart';
import 'package:rgb_app/devices/bluetooth_device_interface.dart';

class Bluno extends BluetoothDeviceInterface {
  final int ledCount;

  @override
  List<Color> get colors => _colors;

  List<Color> _colors;

  @override
  String get serviceId => '0000dfb0-0000-1000-8000-00805f9b34fb';

  @override
  String get characteristicId => '0000dfb1-0000-1000-8000-00805f9b34fb';

  Bluno({
    required this.ledCount,
    required super.deviceData,
    super.sendInChunks,
  }) : _colors = List<Color>.generate(
          ledCount,
          (_) => Colors.white,
        );

  @override
  void blink() {
    // TODO: implement blink
  }

  @override
  Size getSize() => Size(ledCount.toDouble(), 1);

  @override
  void test() {
    // TODO: implement test
  }

  @override
  void update() {
    try {
      final List<Color> newColors = <Color>[];
      for (int i = 0; i < colors.length; i++) {
        final Color newColor = effectsColorsCubit.colors[offsetY][offsetX + i];
        newColors.add(newColor);
      }
      _colors = newColors;
    } catch (e) {
      print('$offsetX, $offsetY out of range ${deviceData.name}');
    }

    super.update();
  }
}
