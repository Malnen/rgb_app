import 'package:flutter/material.dart';
import 'package:rgb_app/devices/enums/transfer_type.dart';
import 'package:rgb_app/devices/mixins/control_transfer_device.dart';
import 'package:rgb_app/devices/mouse_interface.dart';
import 'package:rgb_app/testers/steel_series_rival_3_tester.dart';

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
  int get timeout => 10;

  @override
  int get interface => 3;

  @override
  int get configuration => 1;

  @override
  TransferType get transferType => TransferType.control;

  List<Color> colors = <Color>[
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
  ];

  SteelSeriesRival3({required super.deviceData});

  @override
  void init() {
    super.init();
    tester = SteelSeriesRival3Tester(steelSeriesRival3: this);
    //test();
    //blink();
  }

  @override
  Size getSize() => Size(1, 3);

  @override
  List<List<int>> getPackets() {
    return <List<int>>[
      <int>[
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
        0x00,
      ]
    ];
  }

  @override
  void test() => tester.test();

  @override
  void blink() => tester.blink();

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
        final Color newColor = effectsColorsCubit.colors[offsetY + i][offsetX];
        newColors.add(newColor);
      }
      colors = newColors;
    } catch (e) {
      print('$offsetX, $offsetY out of range ${deviceData.deviceProductVendor.name}');
    }

    super.update();
  }
}
