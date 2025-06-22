import 'package:flutter/material.dart';
import 'package:rgb_app/devices/enums/transfer_type.dart';
import 'package:rgb_app/devices/mixins/control_transfer_device.dart';
import 'package:rgb_app/devices/mouse_interface.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/testers/steel_series_rival_3_tester.dart';
import 'package:vector_math/vector_math.dart';

class SteelSeriesRival3 extends MouseInterface with ControlTransferDevice {
  late SteelSeriesRival3Tester tester;

  @override
  int get requestType => 0x21;

  @override
  int get request => 0x09;

  @override
  int get value => 0x200;

  @override
  int get index => 0x03;

  @override
  int get dataLength => 32;

  @override
  int get interface => 3;

  @override
  int get configuration => 1;

  @override
  TransferType get transferType => TransferType.control;

  @override
  List<List<int>> get initializePackets => <List<int>>[];

  List<Color> colors = <Color>[
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
  ];

  SteelSeriesRival3({required super.deviceData, required super.usbDeviceDataSender});

  @override
  Future<void> init() async {
    await super.init();
    tester = SteelSeriesRival3Tester(steelSeriesRival3: this);
    //test();
    //blink();
  }

  @override
  Vector3 getSize() => Vector3(1, 1, 3);

  @override
  List<List<int>> getPackets() {
    return <List<int>>[
      <int>[
        0x0a,
        0x00,
        0x0f,
        colors[0].redInt,
        colors[0].greenInt,
        colors[0].blueInt,
        colors[1].redInt,
        colors[1].greenInt,
        colors[1].blueInt,
        colors[2].redInt,
        colors[2].greenInt,
        colors[2].blueInt,
        colors[2].redInt,
        colors[2].greenInt,
        colors[2].blueInt,
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
      ]
    ];
  }

  @override
  void test() => tester.test();

  @override
  void blink() => tester.blink();

  @override
  Future<void> dispose() async {
    tester.dispose();
    await super.dispose();
  }

  @override
  void update() {
    try {
      final List<Color> newColors = <Color>[];
      for (int i = 0; i < colors.length; i++) {
        final Color newColor = getColorAt(x: 0, y: 0, z: i);
        newColors.add(newColor);
      }
      colors = newColors;
    } catch (e) {
      print('$offsetX, $offsetZ out of range ${deviceData.name}');
    }

    super.update();
  }
}
