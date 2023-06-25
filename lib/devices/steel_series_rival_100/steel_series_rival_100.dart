import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/mouse_interface.dart';
import 'package:rgb_app/extensions/pointer_extension.dart';
import 'package:rgb_app/extensions/uint_8_list_blob_conversion_extension.dart';
import 'package:rgb_app/testers/steel_series_rival_100_tester.dart';

class SteelSeriesRival100 extends MouseInterface {
  late SteelSeriesRival100Tester tester;

  Color color = Color.fromARGB(1, 0, 0, 0);

  SteelSeriesRival100({
    required super.deviceData,
  });

  @override
  void init() {
    super.init();
    tester = SteelSeriesRival100Tester(steelSeriesRival100: this);
    //test();
    //blink();
  }

  @override
  Size getSize() {
    return Size(1, 1);
  }

  @override
  void sendData() {
    final Uint8List data = Uint8List.fromList(<int>[
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

    final ffi.Pointer<ffi.Uint8> pointer = data.allocatePointer();
    libusb.libusb_control_transfer(
      devHandle,
      0x21,
      0x09,
      0x200,
      0x00,
      pointer,
      32,
      10,
    );
    pointer.free();
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
      print(offsetX.toString() + ', ' + offsetY.toString() + ' out of range ' + deviceData.deviceProductVendor.name);
    }

    super.update();
  }

  @override
  void initDevHandle() {
    devHandle = DeviceInterface.initDeviceHandler(
      deviceData: deviceData,
      configuration: 1,
      interface: 0,
    );
  }
}
