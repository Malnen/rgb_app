import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';

class UnknownDevice extends DeviceInterface {
  UnknownDevice({required super.deviceData});

  @override
  void init() {}

  @override
  void test() {}

  @override
  void blink() {}

  @override
  void update() {}

  @override
  Size getSize() {
    return Size(0, 0);
  }

  @override
  int get configuration => throw UnimplementedError();

  @override
  int get interface => throw UnimplementedError();

  @override
  Map<String, Object> getDataToSend() {
    throw UnimplementedError();
  }

  @override
  List<List<int>> getPackets() {
    throw UnimplementedError();
  }
}
