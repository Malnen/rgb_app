import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/smbus_device_details.dart';
import 'package:rgb_app/utils/smbus/smbus.dart';

class KingstonFuryRamDetector {
  final Smbus smbus;

  KingstonFuryRamDetector(this.smbus);

  Future<List<SMBusDeviceData>> scan() async {
    final List<int> possibleAddresses = <int>[0x60, 0x61, 0x62, 0x63, 0x58, 0x59, 0x5A, 0x5B];
    final List<int> foundAddresses = <int>[];

    for (final int address in possibleAddresses) {
      final bool quick = await writeQuick(address);
      if (!quick) {
        continue;
      }

      await Future<void>.delayed(const Duration(milliseconds: 30));

      final bool isFury = await checkForHyperFuryRam(address);
      if (isFury) {
        print('✅ Kingston HyperX Fury RAM Found at Address: 0x${address.toRadixString(16).toUpperCase()}');
        foundAddresses.add(address);
      }
    }

    return foundAddresses
        .map(
          (int address) => SMBusDeviceData(
            smBusDeviceDetails: SMBusDeviceDetails(
              name: 'Kingston Hyper Fury Ram',
              address: address,
            ),
            connected: true,
            key: UniqueKey(),
          ),
        )
        .toList();
  }

  Future<bool> writeQuick(int address) async {
    try {
      await smbus.writeQuick(address: address);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkForHyperFuryRam(int address) async {
    await smbus.writeByte(address: address, command: 0x08, value: 0x53);
    final List<int> nameReturnBytes = <int>[];
    for (int i = 0; i < 4; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 30));
      final int word = await smbus.readWord(address: address, command: i + 1);
      final int highByte = (word >> 8) & 0xFF;
      nameReturnBytes.add(highByte);
    }

    final String deviceName = String.fromCharCodes(nameReturnBytes);
    final bool isFury = deviceName.contains('FURY') || (deviceName.contains('URY') && nameReturnBytes[0] == 6);

    await Future<void>.delayed(const Duration(milliseconds: 30));
    await smbus.writeByte(address: address, command: 0x08, value: 0x44);

    return isFury;
  }
}
