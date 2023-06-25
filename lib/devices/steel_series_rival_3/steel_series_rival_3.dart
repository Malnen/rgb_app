import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/mouse_interface.dart';
import 'package:rgb_app/extensions/pointer_extension.dart';
import 'package:rgb_app/extensions/uint_8_list_blob_conversion_extension.dart';
import 'package:rgb_app/testers/steel_series_rival_3_tester.dart';

class SteelSeriesRival3 extends MouseInterface {
  late SteelSeriesRival3Tester tester;

  List<Color> colors = <Color>[
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
  ];

  SteelSeriesRival3({
    required super.deviceData,
  });

  @override
  void init() {
    super.init();
    tester = SteelSeriesRival3Tester(steelSeriesRival3: this);
    //test();
    //blink();
  }

  @override
  Size getSize() {
    return Size(1, 3);
  }

  @override
  void sendData() {
    final Uint8List data = Uint8List.fromList(<int>[
      0x0a,
      0x00,
      0x0f,
      colors[0].red,
      colors[0].green,
      colors[0].blue,
      colors[1].red,
      colors[1].green,
      colors[1].blue,
      colors[2].red,
      colors[2].green,
      colors[2].blue,
      colors[2].red,
      colors[2].green,
      colors[2].blue,
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
      0x03,
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
      final List<Color> newColors = <Color>[];
      for (int i = 0; i < colors.length; i++) {
        final Color newColor = effectBloc.colors[offsetY + i][offsetX];
        newColors.add(newColor);
      }
      colors = newColors;
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
      interface: 3,
    );
  }
}
