import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rgb_app/devices/corsair_galleon_keyboard/corsair_galleon_key_dictionary.dart';
import 'package:rgb_app/devices/enums/transfer_type.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';
import 'package:rgb_app/devices/keyboard_key.dart';
import 'package:rgb_app/devices/mixins/interrupt_transfer_device.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:vector_math/vector_math.dart';

class CorsairGalleonKeyboard extends KeyboardInterface with InterruptTransferDevice {
  static const int _defaultReportLength = 64;
  static const int _deviceId = 0x00;
  static const int _lightingHandle = 0x00;
  static const int _lightingControllerEndpoint = 0x22;
  static const int _lightingControllerDataType = 0x12;
  static const int _ledSpacing = 146;
  static const int _getPropertyCommand = 0x02;
  static const int _setPropertyCommand = 0x01;
  static const int _writeCommand = 0x06;
  static const int _streamCommand = 0x07;
  static const int _openHandleCommand = 0x0D;
  static const int _modeProperty = 0x03;
  static const int _brightnessProperty = 0x02;
  static const int _vidProperty = 0x11;
  static const int _pidProperty = 0x12;
  static const int _pollingRateProperty = 0x01;
  static const int _maxPollingRateProperty = 0x96;
  static const int _firmwareProperty = 0x13;
  static const int _softwareMode = 0x02;
  static const int _fullBrightness = 1000;

  late Map<Vector3, List<KeyboardKey>> keys;
  late List<int> rgbData;
  late List<int> lightingControllerRgbData;
  int _writeLength = _defaultReportLength;
  int _readLength = _defaultReportLength;

  CorsairGalleonKeyboard({required super.deviceData, required super.deviceDataSender});

  @override
  int get endpoint => 0x01;

  @override
  int get dataLength => _ledSpacing * 3;

  @override
  int get configuration => 1;

  @override
  int get interface => 1;

  @override
  TransferType get transferType => TransferType.interrupt;

  @override
  bool get requiresWriteReadback => false;

  @override
  List<List<int>> get initializePackets => <List<int>>[
        _getPropertyPacket(_modeProperty),
        _setPropertyPacket(_modeProperty, _softwareMode),
        _getPropertyPacket(_modeProperty),
        _getPropertyPacket(_vidProperty),
        _getPropertyPacket(_pidProperty),
        _getPropertyPacket(_pollingRateProperty),
        _getPropertyPacket(_maxPollingRateProperty),
        _getPropertyPacket(_firmwareProperty),
        _getPropertyPacket(_brightnessProperty),
        _setPropertyPacket(_brightnessProperty, _fullBrightness),
        _getPropertyPacket(_brightnessProperty),
        _openHandlePacket(_lightingHandle, _lightingControllerEndpoint),
      ];

  @override
  Future<void> init() async {
    await super.init();
    keys = CorsairGalleonKeyDictionary.keys;
    rgbData = List<int>.filled(dataLength, 0);
    lightingControllerRgbData = List<int>.filled(dataLength, 0);
  }

  void configureHidReportLengths({required int writeLength, required int readLength}) {
    if (writeLength > 0) {
      _writeLength = writeLength;
    }
    if (readLength > 0) {
      _readLength = readLength;
    }
  }

  @override
  Future<void> dispose() async {
    await super.dispose();
  }

  @override
  void blink() {}

  @override
  void test() {}

  @override
  Vector3 getSize() => Vector3(18, 1, 7);

  @override
  Map<String, Object?> getPayload() {
    final List<List<int>> packets = _buildLightingPackets();
    return <String, Object?>{
      'packets': packets,
      'guid': guid,
      ...getDataToSend(),
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

  @override
  Map<String, Object> getDataToSend() => <String, Object>{
        'endpoint': endpoint,
        'length': _writeLength,
        'timeout': 1000,
        'transferType': transferType.name,
        'readAfterPacketIndexes': <int>[0],
        'clearBeforePacketIndexes': <int>[0],
        'readEndpoint': endpoint,
        'readLength': _readLength,
        'readTimeout': 1000,
        'readDelayMs': 10,
      };

  @override
  List<List<int>> getPackets() => _buildLightingPackets();

  @override
  Future<void> sendPacket(List<int> bytes, int length, {Duration delay = const Duration(milliseconds: 10)}) async {
    final List<int> packet = _padPacket(bytes);
    await deviceDataSender.sendData(
      <Map<String, Object?>>[
        getCustomPayload(<List<int>>[packet]),
      ],
      throttled: false,
    );
    await Future<void>.delayed(delay);
  }

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

  List<List<int>> _buildLightingPackets() {
    final List<List<int>> packets = <List<int>>[];
    final List<int> rgbPayload = <int>[
      _lightingControllerDataType,
      0x00,
      ...lightingControllerRgbData,
    ];
    final int initialPayloadSize = _writeLength - 8;
    final int streamPayloadSize = _writeLength - 4;

    final List<int> writePacket = _padPacket(
      <int>[
        0x00,
        _deviceId | 0x08,
        _writeCommand,
        _lightingHandle,
        ..._int32LittleEndian(rgbPayload.length),
        ...rgbPayload.take(initialPayloadSize),
      ],
    );
    packets.add(writePacket);

    int cursor = initialPayloadSize;
    while (cursor < rgbPayload.length) {
      final int chunkSize = (rgbPayload.length - cursor) < streamPayloadSize ? (rgbPayload.length - cursor) : streamPayloadSize;
      final List<int> streamPacket = _padPacket(
        <int>[
          0x00,
          _deviceId,
          _streamCommand,
          _lightingHandle,
          ...rgbPayload.sublist(cursor, cursor + chunkSize),
        ],
      );
      packets.add(streamPacket);
      cursor += chunkSize;
    }

    return packets;
  }

  List<int> _getPropertyPacket(int propertyId) => _padPacket(<int>[
        0x00,
        _deviceId | 0x08,
        _getPropertyCommand,
        ..._int16LittleEndian(propertyId),
      ]);

  List<int> _setPropertyPacket(int propertyId, int value) => _padPacket(<int>[
        0x00,
        _deviceId | 0x08,
        _setPropertyCommand,
        propertyId,
        0x00,
        value & 0xFF,
        (value >> 8) & 0xFF,
        (value >> 16) & 0xFF,
      ]);

  List<int> _openHandlePacket(int handle, int endpoint) => _padPacket(<int>[
        0x00,
        _deviceId | 0x08,
        _openHandleCommand,
        handle,
        endpoint,
      ]);

  List<int> _padPacket(List<int> bytes) {
    final List<int> packet = List<int>.filled(_writeLength, 0x00);
    for (int i = 0; i < bytes.length && i < _writeLength; i++) {
      packet[i] = bytes[i];
    }
    return packet;
  }

  List<int> _int16LittleEndian(int value) => <int>[
        value & 0xFF,
        (value >> 8) & 0xFF,
      ];

  List<int> _int32LittleEndian(int value) => <int>[
        value & 0xFF,
        (value >> 8) & 0xFF,
        (value >> 16) & 0xFF,
        (value >> 24) & 0xFF,
      ];
}
