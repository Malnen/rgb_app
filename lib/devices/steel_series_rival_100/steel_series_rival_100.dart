import 'package:flutter/material.dart';
import 'package:rgb_app/devices/enums/transfer_type.dart';
import 'package:rgb_app/devices/mixins/control_transfer_device.dart';
import 'package:rgb_app/devices/mouse_interface.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/testers/steel_series_rival_100_tester.dart';
import 'package:vector_math/vector_math.dart';

class SteelSeriesRival100 extends MouseInterface with ControlTransferDevice {
  late SteelSeriesRival100Tester tester;

  Color color = Color.fromARGB(1, 0, 0, 0);

  SteelSeriesRival100({required super.deviceData, required super.usbDeviceDataSender});

  @override
  int get requestType => 0x21;

  @override
  int get request => 0x09;

  @override
  int get value => 0x200;

  @override
  int get index => 0x00;

  @override
  int get dataLength => 32;

  @override
  int get configuration => 1;

  @override
  int get interface => 0;

  @override
  TransferType get transferType => TransferType.control;

  @override
  Future<void> init() async {
    await super.init();
    tester = SteelSeriesRival100Tester(steelSeriesRival100: this);
    //test();
    //blink();
  }

  @override
  Vector3 getSize() => Vector3(1, 1, 1);

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
      color = getColorAt(x: 0, y: 0, z: 0);
    } catch (e) {
      print('$offsetX, $offsetZ out of range ${deviceData.name}');
    }

    super.update();
  }

  @override
  List<List<int>> get initializePackets => <List<int>>[];

  @override
  List<List<int>> getPackets() => <List<int>>[
        <int>[
          0x05,
          0x00,
          color.redInt,
          color.greenInt,
          color.blueInt,
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
