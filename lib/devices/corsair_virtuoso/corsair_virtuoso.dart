import 'package:flutter/material.dart';
import 'package:rgb_app/devices/mixins/interrupt_transfer_device.dart';
import 'package:rgb_app/devices/usb_device_interface.dart';
import 'package:rgb_app/testers/corsair_virtuoso_tester.dart';
import 'package:vector_math/vector_math.dart';

class CorsairVirtuoso extends UsbDeviceInterface with InterruptTransferDevice {
  Color color = Color.fromARGB(1, 0, 0, 0);

  late CorsairVirtuosoTester tester;

  CorsairVirtuoso({required super.deviceData, required super.usbDeviceDataSender});

  @override
  int get endpoint => 0x02;

  @override
  int get dataLength => 64;

  @override
  int get configuration => 1;

  @override
  int get interface => 4;

  @override
  Future<void> init() async {
    await super.init();
    tester = CorsairVirtuosoTester(corsairVirtuoso: this);
  }

  @override
  void blink() {
    // TODO: implement blink
  }

  @override
  void test() => tester.test();

  @override
  void update() {
    color = getColorAt(x: 0, y: 0, z: 0);
    super.update();
  }

  @override
  Vector3 getSize() => Vector3(1, 1, 1);

  @override
  List<List<int>> get initializePackets => <List<int>>[];

  @override
  List<List<int>> getPackets() => <List<int>>[
        <int>[
          0x02,
          0x09,
          0x06,
          0x00,
          0x09,
          0x00,
          0x00,
          0x00,
          0xff, //r
          0xff,
          0xff,
          0x00, //g
          0x00,
          0x00,
          0x00, //b
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
        ],
      ];
}
