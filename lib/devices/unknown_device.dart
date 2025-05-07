import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';

class UnknownDevice extends DeviceInterface {
  UnknownDevice({required super.deviceData});

  @override
  Future<void> init() async {}

  @override
  void test() {}

  @override
  void blink() {}

  @override
  void update() {}

  @override
  Size getSize() => Size(0, 0);
}
