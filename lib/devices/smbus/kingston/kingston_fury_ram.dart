import 'dart:ui';

import 'package:rgb_app/devices/smbus/models/smbus_transaction_data.dart';
import 'package:rgb_app/devices/smbus/models/smbus_transaction_entry.dart';
import 'package:rgb_app/devices/smbus/smbus_device_interface.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/utils/smbus/smbus.dart';

class KingstonFuryRam extends SMBusDeviceInterface {
  static const String name = 'Kingston Hyper Fury Ram';

  final Smbus smbus;

  List<Color> colors = <Color>[
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
    Color.fromARGB(1, 0, 0, 0),
  ];

  KingstonFuryRam({required super.deviceData, required this.smbus});

  @override
  SMBusTransactionData get colorData => _getColorData();

  @override
  Future<void> init() async {
    await _setMode();
  }

  @override
  Future<void> update() async {
    final List<Color> newColors = <Color>[];
    for (int i = 0; i < colors.length; i++) {
      final Color newColor = effectsColorsCubit.colors[offsetY + i][offsetX];
      newColors.add(newColor);
    }
    colors = newColors;
  }

  @override
  void blink() {
    // Optional: Not needed here yet
  }

  @override
  Size getSize() {
    return Size(1, 12);
  }

  @override
  void test() {
    // Optional: Not needed yet
  }

  Future<void> _setMode() async {
    final int address = deviceData.smBusDeviceDetails.address;
    final List<SMBusTransactionEntry> entries = <SMBusTransactionEntry>[
      SMBusTransactionEntry(0x08, 0x53),
      SMBusTransactionEntry(0x0B, 0x00),
      SMBusTransactionEntry(0x09, 0x10),
      SMBusTransactionEntry(0x0C, 0x01),
      SMBusTransactionEntry(0x20, 0x50),
      SMBusTransactionEntry(0x08, 0x44),
    ];
    await smbus.writeTransactionBatch(
      transactions: <SMBusTransactionData>[
        SMBusTransactionData(address, entries),
      ],
    );
  }

  SMBusTransactionData _getColorData() {
    return SMBusTransactionData(deviceData.smBusDeviceDetails.address, <SMBusTransactionEntry>[
      SMBusTransactionEntry(0x08, 0x53),
      for (int i = 0; i < colors.length; i++) ...<SMBusTransactionEntry>[
        SMBusTransactionEntry(0x50 + i * 3, colors[colors.length - 1 - i].redInt),
        SMBusTransactionEntry(0x50 + i * 3 + 1, colors[colors.length - 1 - i].greenInt),
        SMBusTransactionEntry(0x50 + i * 3 + 2, colors[colors.length - 1 - i].blueInt),
      ],
      SMBusTransactionEntry(0x08, 0x44),
    ]);
  }
}
