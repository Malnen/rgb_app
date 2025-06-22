import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/devices/corsair_keyboard/corsair_keyboard_packets.dart';
import 'package:rgb_app/devices/enums/transfer_type.dart';
import 'package:rgb_app/devices/key_dictionary.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';
import 'package:rgb_app/devices/keyboard_key.dart';
import 'package:rgb_app/devices/mixins/interrupt_transfer_device.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/extensions/vector_3_extension.dart';
import 'package:rgb_app/models/effect_grid_data.dart';
import 'package:rgb_app/packet_managers/corsair_k70_packet_manager.dart';
import 'package:rgb_app/testers/corsair_keyboard_tester.dart';
import 'package:vector_math/vector_math.dart';

class CorsairKeyboard extends KeyboardInterface with InterruptTransferDevice {
  final KeyBloc keyBloc;

  late CorsairKeyboardTester tester;

  CorsairKeyboard({required super.usbDeviceDataSender, required super.deviceData}) : keyBloc = GetIt.instance.get();

  late List<int> dataPkt1;
  late List<int> rPkt1;
  late List<int> gPkt1;
  late List<int> bPkt1;

  late List<int> dataPkt2;
  late List<int> rPkt2;
  late List<int> gPkt2;
  late List<int> bPkt2;

  late List<int> dataPkt3;
  late List<int> rPkt3;
  late List<int> gPkt3;
  late List<int> bPkt3;
  late List<List<int>> packets;
  late CorsairK70PacketManager packetManager;

  late final Map<Vector3, List<KeyboardKey>> keys;

  @override
  int get endpoint => 0x02;

  @override
  int get dataLength => 64;

  @override
  int get configuration => 1;

  @override
  int get interface => 1;

  @override
  TransferType get transferType => TransferType.interrupt;

  @override
  Future<void> init() async {
    await super.init();
    keys = KeyDictionary.keys[deviceData.deviceProductVendor.productVendor] ?? <Vector3, List<KeyboardKey>>{};
    _setMinMax();
    tester = CorsairKeyboardTester(
      corsairKeyboard: this,
    );
    packetManager = CorsairK70PacketManager(this);
    packetManager.fill();
    _storePackets();
    //test();
    //blink();
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
      _updateKeys();
    } catch (_) {
      print('$offsetX, $offsetZ out of range ${deviceData.name}');
    }

    super.update();
  }

  @override
  Vector3 getSize() => Vector3(23, 1, 7);

  @override
  List<List<int>> getPackets() => packets;

  @override
  List<List<int>> get initializePackets => <List<int>>[
        <int>[7, 5, 2, 0, 3],
        <int>[7, 4, 2],
        <int>[
          7,
          64,
          30,
          0,
          0,
          128,
          1,
          128,
          2,
          128,
          3,
          128,
          4,
          128,
          5,
          128,
          6,
          128,
          7,
          128,
          8,
          128,
          9,
          128,
          10,
          128,
          11,
          128,
          12,
          128,
          13,
          128,
          14,
          128,
          15,
          128,
          16,
          128,
          17,
          128,
          18,
          128,
          19,
          128,
          20,
          128,
          21,
          128,
          22,
          128,
          23,
          128,
          24,
          128,
          25,
          128,
          26,
          128,
          27,
          128,
          28,
          128,
          29,
          128,
        ],
        <int>[
          7,
          64,
          30,
          0,
          30,
          128,
          31,
          128,
          32,
          128,
          33,
          128,
          34,
          128,
          35,
          128,
          36,
          128,
          37,
          128,
          38,
          128,
          39,
          128,
          40,
          128,
          41,
          128,
          42,
          128,
          43,
          128,
          44,
          128,
          45,
          128,
          46,
          128,
          47,
          128,
          48,
          128,
          49,
          128,
          50,
          128,
          51,
          128,
          52,
          128,
          53,
          128,
          54,
          128,
          55,
          128,
          56,
          128,
          57,
          128,
          58,
          128,
          59,
          128,
        ],
        <int>[
          7,
          64,
          30,
          0,
          60,
          128,
          61,
          128,
          62,
          128,
          64,
          128,
          67,
          128,
          68,
          128,
          69,
          128,
          72,
          128,
          73,
          128,
          74,
          128,
          75,
          128,
          76,
          128,
          77,
          128,
          78,
          128,
          79,
          128,
          81,
          128,
          82,
          128,
          84,
          128,
          86,
          128,
          87,
          128,
          88,
          128,
          89,
          128,
          90,
          128,
          91,
          128,
          92,
          128,
          93,
          128,
          94,
          128,
          95,
          128,
          97,
          128,
          98,
          128,
        ],
        <int>[
          7,
          64,
          22,
          0,
          99,
          128,
          100,
          128,
          101,
          128,
          102,
          128,
          103,
          128,
          104,
          128,
          105,
          128,
          106,
          128,
          107,
          128,
          108,
          128,
          109,
          128,
          110,
          128,
          112,
          128,
          113,
          128,
          114,
          128,
          115,
          128,
          116,
          128,
          117,
          128,
          118,
          128,
          119,
          128,
          130,
          128,
          131,
          128,
        ]
      ];

  void _storePackets() {
    packets = <List<int>>[
      rPkt1,
      rPkt2,
      rPkt3,
      dataPkt1,
      gPkt1,
      gPkt2,
      gPkt3,
      dataPkt2,
      bPkt1,
      bPkt2,
      bPkt3,
      dataPkt3,
    ];
  }

  void _updateKeys() {
    for (MapEntry<Vector3, List<KeyboardKey>> entry in keys.entries) {
      final Vector3 point = entry.key;
      final List<KeyboardKey> keyList = entry.value;

      for (KeyboardKey key in keyList) {
        try {
          final int packetIndex = key.packetIndex;
          final int index = key.index;

          final Color color = getColorAt(x: point.x.toInt(), y: point.y.toInt(), z: point.z.toInt());
          final int r = color.redInt;
          final int g = color.greenInt;
          final int b = color.blueInt;

          if (packetIndex >= 0) {
            final CorsairKeyboardPackets corsairK70Packets = getPacket(packetIndex);

            corsairK70Packets.rPkt[index] = r;
            corsairK70Packets.gPkt[index] = g;
            corsairK70Packets.bPkt[index] = b;
          }
        } catch (error) {
          print('Error updating key at $point: $error');
        }
      }
    }
  }

  CorsairKeyboardPackets getPacket(int index) => switch (index) {
        0 => CorsairKeyboardPackets(
            rPkt: rPkt1,
            gPkt: gPkt1,
            bPkt: bPkt1,
          ),
        1 => CorsairKeyboardPackets(
            rPkt: rPkt2,
            gPkt: gPkt2,
            bPkt: bPkt2,
          ),
        2 => CorsairKeyboardPackets(
            rPkt: rPkt3,
            gPkt: gPkt3,
            bPkt: bPkt3,
          ),
        _ => CorsairKeyboardPackets.empty(),
      };

  void _setMinMax() {
    final Iterable<Vector3> keyPositions = keys.keys;
    final int maximumGridX = _getMaximumGridX(keyPositions) + 1;
    final int maximumGridY = _getMaximumGridY(keyPositions) + 1;
    final int maximumGridZ = _getMaximumGridZ(keyPositions) + 1;
    final EffectState currentEffectState = effectBloc.state;
    final EffectGridData currentGridData = currentEffectState.effectGridData;
    final int currentMinimumGridX = currentGridData.minSizeX;
    final int currentMinimumGridY = currentGridData.minSizeY;
    final int currentMinimumGridZ = currentGridData.minSizeZ;
    final int adjustedMinimumGridX = currentMinimumGridX < maximumGridX ? maximumGridX : currentMinimumGridX;
    final int adjustedMinimumGridY = currentMinimumGridY < maximumGridY ? maximumGridY : currentMinimumGridY;
    final int adjustedMinimumGridZ = currentMinimumGridZ < maximumGridZ ? maximumGridZ : currentMinimumGridZ;
    final SetGridSizeEvent setGridSizeEvent = SetGridSizeEvent(
      effectGridData: currentGridData.copyWith(
        minSize: currentGridData.minSize.copyWith(
          x: adjustedMinimumGridX.toDouble(),
          y: adjustedMinimumGridY.toDouble(),
          z: adjustedMinimumGridZ.toDouble(),
        ),
      ),
    );

    effectBloc.add(setGridSizeEvent);
  }

  int _getMaximumGridX(Iterable<Vector3> keyPositions) =>
      keyPositions.isEmpty ? 0 : keyPositions.map((Vector3 position) => position.x.toInt()).reduce(max);

  int _getMaximumGridY(Iterable<Vector3> keyPositions) =>
      keyPositions.isEmpty ? 0 : keyPositions.map((Vector3 position) => position.y.toInt()).reduce(max);

  int _getMaximumGridZ(Iterable<Vector3> keyPositions) =>
      keyPositions.isEmpty ? 0 : keyPositions.map((Vector3 position) => position.z.toInt()).reduce(max);
}
