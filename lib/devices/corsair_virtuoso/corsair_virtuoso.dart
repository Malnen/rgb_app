import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/mixins/interrupt_transfer_device.dart';
import 'package:rgb_app/testers/corsair_virtuoso_tester.dart';

class CorsairVirtuoso extends DeviceInterface with InterruptTransferDevice {
  Color color = Color.fromARGB(1, 0, 0, 0);

  late CorsairVirtuosoTester tester;

  CorsairVirtuoso({required super.deviceData});

  @override
  int get endpoint => 0x02;

  @override
  int get length => 64;

  @override
  int get timeout => 10;

  @override
  int get configuration => 1;

  @override
  int get interface => 4;

  @override
  void init() {
    super.init();
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
    color = effectsColorsCubit.colors[offsetY][offsetX];
    super.update();
  }

  @override
  Size getSize() => Size(1, 1);

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
      ],
    ];
}
