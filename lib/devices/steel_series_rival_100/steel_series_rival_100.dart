import 'package:flutter/material.dart';
import 'package:rgb_app/devices/enums/transfer_type.dart';
import 'package:rgb_app/devices/mixins/control_transfer_device.dart';
import 'package:rgb_app/devices/mouse_interface.dart';
import 'package:rgb_app/testers/steel_series_rival_100_tester.dart';

class SteelSeriesRival100 extends MouseInterface with ControlTransferDevice {
  late SteelSeriesRival100Tester tester;

  Color color = Color.fromARGB(1, 0, 0, 0);

  SteelSeriesRival100({
    required super.deviceData,
  });

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
  int get timeout => 10;

  @override
  int get configuration => 1;

  @override
  int get interface => 0;

  @override
  TransferType get transferType => TransferType.control;

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
      color = effectsColorsCubit.colors[offsetY][offsetX];
    } catch (e) {
      print('$offsetX, $offsetY out of range ${deviceData.deviceProductVendor.name}');
    }

    super.update();
  }

  @override
  List<List<int>> getPackets() {
    return <List<int>>[
      <int>[
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
        0x00,
      ],
    ];
  }
}
