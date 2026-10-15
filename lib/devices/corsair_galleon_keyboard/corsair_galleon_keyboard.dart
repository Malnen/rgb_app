import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rgb_app/devices/corsair_galleon_keyboard/corsair_galleon_key_dictionary.dart';
import 'package:rgb_app/devices/corsair_galleon_keyboard/corsair_galleon_lighting.dart';
import 'package:rgb_app/devices/enums/transfer_type.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';
import 'package:rgb_app/devices/keyboard_key.dart';
import 'package:rgb_app/devices/mixins/interrupt_transfer_device.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/utils/corsair/bragi/corsair_bragi_protocol.dart';
import 'package:rgb_app/utils/frame_throttler.dart';
import 'package:vector_math/vector_math.dart';

class CorsairGalleonKeyboard extends KeyboardInterface with InterruptTransferDevice {
  static const int _defaultReportLength = 64;
  static const int _ledSpacing = CorsairGalleonLighting.ledCount;

  late Map<Vector3, List<KeyboardKey>> keys;
  late List<int> rgbData;
  late List<int> lightingControllerRgbData;
  int _writeLength = _defaultReportLength;
  int _readLength = _defaultReportLength;
  CorsairGalleonLighting? _lighting;

  CorsairGalleonKeyboard({required super.deviceData, required super.deviceDataSender});

  @override
  int get endpoint => 0x01;

  @override
  int get configuration => 1;

  @override
  int get interface => 1;

  @override
  TransferType get transferType => TransferType.interrupt;

  @protected
  @override
  int get dataLength => _ledSpacing * 3;

  @protected
  @override
  bool get requiresWriteReadback => false;

  @protected
  @override
  List<List<int>> get initializePackets => _activeLighting.initializationPackets;

  CorsairGalleonLighting get _activeLighting {
    final CorsairGalleonLighting? lighting = _lighting;
    if (lighting != null) {
      return lighting;
    }

    throw StateError('Galleon protocol has not been initialized');
  }

  @override
  Future<void> init() async {
    keys = CorsairGalleonKeyDictionary.keys;
    rgbData = List<int>.filled(dataLength, 0);
    lightingControllerRgbData = List<int>.filled(dataLength, 0);
    final CorsairBragiProtocol protocol = CorsairBragiProtocol(reportLength: _writeLength, write: _writePacket, read: _readPacket);
    _lighting = CorsairGalleonLighting(protocol: protocol);
    await super.init();
  }

  @override
  Future<void> dispose() async {
    if (!isOpen.isClosed) {
      isOpen.add(false);
    }

    try {
      if (deviceDataSender case final FrameThrottler sender) {
        await sender.waitForIdle();
      }

      final CorsairGalleonLighting? lighting = _lighting;
      if (lighting != null) {
        await lighting.close();
      }
    } finally {
      await super.dispose();
    }
  }

  @override
  void blink() {}

  @override
  void test() {}

  @override
  Vector3 getSize() => Vector3(18, 1, 7);

  @override
  Map<String, Object?> getPayload() {
    final List<List<int>> packets = getPackets();
    final Map<String, Object> transport = getDataToSend();

    return <String, Object?>{
      'packets': packets,
      'guid': guid,
      ...transport,
      'readAfterPacketIndexes': <int>[],
      'clearBeforePacketIndexes': <int>[],
    };
  }

  @override
  void update() {
    try {
      _updateKeys();
    } catch (_) {
      // Keep rendering loop alive if effect coordinates are temporarily out of range.
    }

    super.update();
  }

  void configureHidReportLengths({required int writeLength, required int readLength}) {
    if (writeLength > 0) {
      _writeLength = writeLength;
    }

    if (readLength > 0) {
      _readLength = readLength;
    }
  }

  @protected
  @override
  Map<String, Object> getDataToSend() => <String, Object>{
        'endpoint': endpoint,
        'length': _writeLength,
        'timeout': 1000,
        'transferType': transferType.name,
        'readAfterPacketIndexes': <int>[],
        'clearBeforePacketIndexes': <int>[],
        'readEndpoint': endpoint,
        'readLength': _readLength,
        'readTimeout': 1000,
        'readDelayMs': 0,
      };

  @protected
  @override
  List<List<int>> getPackets() => _activeLighting.lightingPackets(lightingControllerRgbData);

  @protected
  @override
  Future<void> initializeDevice() => _activeLighting.initialize();

  @protected
  @override
  Future<void> sendPacket(List<int> bytes, int length, {Duration delay = const Duration(milliseconds: 10)}) async {
    await _activeLighting.execute(bytes);
    await Future<void>.delayed(delay);
  }

  Future<void> _writePacket(List<int> packet) async {
    final Map<String, Object?> payload = getCustomPayload(<List<int>>[packet]);
    await deviceDataSender.sendData(<Map<String, Object?>>[payload], throttled: false);
  }

  Future<List<int>> _readPacket(int timeout) => deviceDataSender.readData(
        guid: guid,
        endpoint: endpoint,
        length: _readLength,
        timeout: timeout,
      );

  void _updateKeys() {
    rgbData = List<int>.filled(dataLength, 0);
    lightingControllerRgbData = List<int>.filled(dataLength, 0);

    for (MapEntry<Vector3, List<KeyboardKey>> entry in keys.entries) {
      final Vector3 point = entry.key;
      final int x = point.x.toInt();
      final int y = point.y.toInt();
      final int z = point.z.toInt();
      final Color color = getColorAt(x: x, y: y, z: z);

      for (KeyboardKey key in entry.value) {
        final int ledIndex = key.index;
        if (ledIndex < 0 || ledIndex >= _ledSpacing) {
          continue;
        }

        rgbData[ledIndex] = color.redInt;
        rgbData[ledIndex + _ledSpacing] = color.greenInt;
        rgbData[ledIndex + (_ledSpacing * 2)] = color.blueInt;
        lightingControllerRgbData[ledIndex * 3] = color.redInt;
        lightingControllerRgbData[(ledIndex * 3) + 1] = color.greenInt;
        lightingControllerRgbData[(ledIndex * 3) + 2] = color.blueInt;
      }
    }
  }
}
