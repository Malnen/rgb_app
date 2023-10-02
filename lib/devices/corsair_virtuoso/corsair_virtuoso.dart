import 'dart:ffi' as ffi;
import 'dart:typed_data';

import 'package:ffi/ffi.dart' show calloc;
import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/extensions/pointer_extension.dart';
import 'package:rgb_app/extensions/uint_8_list_blob_conversion_extension.dart';
import 'package:rgb_app/testers/corsair_virtuoso_tester.dart';

class CorsairVirtuoso extends DeviceInterface {
  Color color = Color.fromARGB(1, 0, 0, 0);

  late CorsairVirtuosoTester tester;

  CorsairVirtuoso({
    required super.deviceData,
  });

  @override
  void init() {
    super.init();
    tester = CorsairVirtuosoTester(corsairVirtuoso: this);
    sendData();
  }

  @override
  void blink() {
    // TODO: implement blink
  }

  @override
  void sendData() {
    final Uint8List data = Uint8List.fromList(<int>[
      0x02,
      0x09,
      0x06,
      0x00,
      0x09,
      0x00,
      0x00,
      0x00,
      color.red,
      0xff,
      0x00,
      color.green,
      0xbe,
      0xff,
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
    ]);
    final ffi.Pointer<ffi.Uint8> pointer = data.allocatePointer();
    final ffi.Pointer<ffi.Int32> actualLength = calloc<ffi.Int32>();
    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      pointer,
      64,
      actualLength,
      1000,
    );
    pointer.free();
    actualLength.free();
  }

  @override
  void test() {
    tester.test();
  }

  @override
  void update() {
    color = effectsColorsCubit.colors[offsetY][offsetX];
    super.update();
  }

  @override
  Size getSize() {
    return Size(1, 1);
  }

  @override
  void initDevHandle() {
    devHandle = DeviceInterface.initDeviceHandler(
      deviceData: deviceData,
      configuration: 1,
      interface: 4,
    );
  }
}
