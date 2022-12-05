import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';

class UnknownDevice extends DeviceInterface {
  UnknownDevice({required super.device});

  @override
  void init() {}

  @override
  void sendData() {}

  @override
  void test() {}

  @override
  void blink() {}

  @override
  void update() {}

  @override
  void initDevHandle() {}

  @override
  Size getSize() {
    return Size(0, 0);
  }
}
