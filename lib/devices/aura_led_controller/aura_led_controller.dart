import 'dart:ui';

import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/mixins/control_transfer_device.dart';

class AuraLEDController extends DeviceInterface with ControlTransferDevice {
  AuraLEDController({required super.deviceData});

  List<Color> colors = <Color>[
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
  ];

  @override
  int get dataLength => 65;

  @override
  int get index => 2;

  @override
  int get request => 0x09;

  @override
  int get requestType => 0x21;

  @override
  int get timeout => 10;

  @override
  int get value => 0x02ec;

  @override
  int get configuration => 1;

  @override
  int get interface => 3;

  @override
  void blink() {
    // TODO: implement blink
  }

  @override
  List<List<int>> getPackets() {
    return <List<int>>[
      <int>[
        0xec,
        0x40,
        0x84,
        0x00,
        0x03,
        colors[0].red,
        colors[0].green,
        colors[0].blue,
        colors[1].red,
        colors[1].green,
        colors[1].blue,
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

  @override
  Size getSize() => Size(1, 3);

  @override
  void test() {
    // TODO: implement test
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
