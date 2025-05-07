import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/services/bluetooth_service.dart';
import 'package:rgb_app/utils/frame_throttler.dart';
import 'package:win_ble/win_ble.dart';

abstract class BluetoothDeviceInterface extends DeviceInterface with FrameThrottler {
  final bool sendInChunks;

  bool _ready = true;

  String get serviceId;

  String get characteristicId;

  List<Color> get colors;

  @override
  BluetoothDeviceData get deviceData => super.deviceData as BluetoothDeviceData;

  BluetoothDeviceInterface({
    required super.deviceData,
    this.sendInChunks = true,
  });

  @override
  Future<void> dispose() async {
    await WinBle.disconnect(deviceData.bluetoothDeviceDetails.deviceId);
    await super.dispose();
  }

  void sendData() => runThrottled(() async {
        if (_ready) {
          _ready = false;
          if (sendInChunks) {
            await _write('\r[');
            for (int i = 0; i < colors.length; i++) {
              final Color color = colors[i];
              await _write('${color.redInt}');
              await _write(',${color.greenInt},');
              await _write('${color.blueInt}');

              if (i < colors.length - 1) {
                await _write(',');
              }
            }
            await _write(']\n');
          } else {
            String data = '\r[';
            for (int i = 0; i < colors.length; i++) {
              final Color color = colors[i];
              data += '${color.redInt},${color.greenInt},${color.blueInt}';
              if (i < colors.length - 1) data += ',';
            }
            data += ']\n';
            await _write(data);
          }
        }
      });

  Future<void> _write(String data) async {
    _listenForDone();
    await WinBle.write(
      address: deviceData.bluetoothDeviceDetails.deviceId,
      service: serviceId,
      characteristic: characteristicId,
      data: Uint8List.fromList(data.codeUnits),
      writeWithResponse: false,
    ).onError((Object? error, StackTrace stackTrace) {
      print(error);
    });
  }

  void _listenForDone() async {
    String buffer = '';
    final Duration timeout = Duration(seconds: 10);
    final DateTime startTime = DateTime.now();

    while (!_ready) {
      final Duration elapsed = DateTime.now().difference(startTime);
      if (elapsed > timeout) {
        await _handleTimeoutAndReconnect();
        _ready = true;
        break;
      }

      final List<int> data = await WinBle.read(
        address: deviceData.bluetoothDeviceDetails.deviceId,
        serviceId: serviceId,
        characteristicId: characteristicId,
      ).onError((_, __) => <int>[]);

      if (data.isNotEmpty) {
        buffer += String.fromCharCodes(data);
        if (<String>['DONE', 'NE', 'DON', 'DO'].any((String string) => buffer.contains(string))) {
          _ready = true;
          buffer = '';
        } else if (buffer.length > 100) {
          buffer = '';
        }
      }
    }
  }

  Future<void> _handleTimeoutAndReconnect() async {
    final BluetoothService service = GetIt.instance.get();
    await service.connect(deviceData, this);
  }
}
