import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/testers/steel_series_rival_100_tester.dart';
import 'package:rgb_app/extensions/uint_8_list_blob_conversion_extension.dart';

import '../device.dart';

class SteelSeriesRival100 extends DeviceInterface {
  late SteelSeriesRival100Tester tester;

  Color color = Color.fromARGB(1, 0, 0, 0);

  SteelSeriesRival100({required Device device}) : super(device: device);

  @override
  void init() {
    tester = SteelSeriesRival100Tester(steelSeriesRival100: this);
    libusb.libusb_init(nullptr);
    devHandle = DeviceInterface.initDeviceHandler(
      device: device,
      configuration: 1,
      interface: 0,
    );
    //test();
    //blink();
  }

  @override
  void sendData() {
    final Uint8List data = Uint8List.fromList([
      0x05,
      0x00,
      color.red,
      color.green,
      color.blue,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00
    ]);
    libusb.libusb_control_transfer(
      devHandle,
      0x21,
      0x09,
      0x200,
      0x00,
      data.allocatePointer(),
      32,
      10,
    );
  }

  @override
  void test() {
    tester.test();
  }

  @override
  void blink() {
    tester.blink();
  }

  @override
  void dispose() {
    tester.dispose();
    super.dispose();
  }

  @override
  void update() {
    try {
      color = effectBloc.colors[offsetY][offsetX];
    } catch (e) {
      print(offsetX.toString() +
          ', ' +
          offsetY.toString() +
          ' out of range ' +
          device.deviceProductVendor.name);
    }
    sendData();
  }
}
