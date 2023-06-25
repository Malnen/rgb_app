import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/cell_coords.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k_70_packets.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/key_dictionary.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';
import 'package:rgb_app/devices/keyboard_key.dart';
import 'package:rgb_app/enums/key_code.dart';
import 'package:rgb_app/extensions/int_iterable_extension.dart';
import 'package:rgb_app/models/effect_grid_data.dart';
import 'package:rgb_app/packet_managers/corsair_k70_packet_manager.dart';
import 'package:rgb_app/testers/corsair_k70_tester.dart';

class CorsairK70 extends KeyboardInterface {
  final KeyBloc keyBloc;

  late CorsairK70Tester tester;

  CorsairK70({
    required super.deviceData,
  }) : keyBloc = GetIt.instance.get();

  late Uint8List dataPkt1;
  late Uint8List rPkt1;
  late Uint8List gPkt1;
  late Uint8List bPkt1;

  late Uint8List dataPkt2;
  late Uint8List rPkt2;
  late Uint8List gPkt2;
  late Uint8List bPkt2;

  late Uint8List dataPkt3;
  late Uint8List rPkt3;
  late Uint8List gPkt3;
  late Uint8List bPkt3;

  late List<Uint8List> packets;

  late CorsairK70PacketManager packetManager;

  List<List<KeyboardKey>> keys = <List<KeyboardKey>>[];

  @override
  void init() {
    _setKeys();
    tester = CorsairK70Tester(
      corsairK70: this,
    );
    super.init();
    packetManager = CorsairK70PacketManager(this);
    packetManager.fill();
    _storePackets();
    //test();
    //blink();
  }

  @override
  void sendData() {
    packetManager.sendData();
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
      _updateKeys();
    } catch (_) {
      print(offsetX.toString() + ', ' + offsetY.toString() + ' out of range ' + deviceData.deviceProductVendor.name);
    }

    super.update();
  }

  @override
  Size getSize() {
    return Size(23, 7);
  }

  @override
  void initDevHandle() {
    devHandle = DeviceInterface.initDeviceHandler(
      deviceData: deviceData,
      configuration: 1,
      interface: 1,
    );
  }

  void _storePackets() {
    packets = <Uint8List>[
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
    for (int i = 0; i < keys.length; i++) {
      final List<KeyboardKey> keys = this.keys[i];
      _updateKeyRow(keys, i);
    }
  }

  void _updateKeyRow(List<KeyboardKey> keys, int i) {
    for (int j = 0; j < keys.length; j++) {
      final KeyboardKey key = keys[j];
      if (key.keyCode == KeyCode.unknown) continue;

      _updateKey(key, i, j);
    }
  }

  void _updateKey(KeyboardKey key, int i, int j) {
    final int packetIndex = key.packetIndex;
    final int index = key.index;
    final Color color = effectBloc.colors[i + offsetX][j + offsetY];
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;
    final CorsairK70Packets corsairK70Packets = getPacket(packetIndex);

    corsairK70Packets.rPkt[index] = r;
    corsairK70Packets.gPkt[index] = g;
    corsairK70Packets.bPkt[index] = b;
  }

  CorsairK70Packets getPacket(int index) {
    switch (index) {
      case 0:
        return CorsairK70Packets(
          rPkt: rPkt1,
          gPkt: gPkt1,
          bPkt: bPkt1,
        );
      case 1:
        return CorsairK70Packets(
          rPkt: rPkt2,
          gPkt: gPkt2,
          bPkt: bPkt2,
        );
      case 2:
        return CorsairK70Packets(
          rPkt: rPkt3,
          gPkt: gPkt3,
          bPkt: bPkt3,
        );
    }

    return CorsairK70Packets.empty();
  }

  void _setKeys() {
    final Map<CellCoords, KeyboardKey> keys = KeyDictionary.keys;
    final Iterable<MapEntry<CellCoords, KeyboardKey>> keyEntries = keys.entries;
    _setMinMax(keyEntries);
    _setKeysDimensions(keyEntries);
    for (MapEntry<CellCoords, KeyboardKey> entry in keyEntries) {
      _setKey(entry);
    }
  }

  void _setMinMax(Iterable<MapEntry<CellCoords, KeyboardKey>> keyEntries) {
    final int lastY = _getLastKeyY(keyEntries) + 1;
    final int maxX = _getMaxX(keyEntries) + 1;
    final EffectState state = effectBloc.state;
    final EffectGridData effectGridData = state.effectGridData;
    final int currentMinX = effectGridData.minSizeX;
    final int currentMinY = effectGridData.minSizeY;

    final SetGridSizeEvent event = SetGridSizeEvent(
      effectGridData: effectGridData.copyWith(
        minSizeX: currentMinX < maxX ? maxX : currentMinX,
        minSizeY: currentMinY < lastY ? lastY : currentMinY,
      ),
    );
    effectBloc.add(event);
  }

  void _setKeysDimensions(Iterable<MapEntry<CellCoords, KeyboardKey>> keyEntries) {
    final int lastY = _getLastKeyY(keyEntries);
    final int maxX = _getMaxX(keyEntries);

    keys = List<List<KeyboardKey>>.generate(
      lastY + 1,
      (_) => List<KeyboardKey>.generate(maxX + 1, (_) => KeyDictionary.emptyKey, growable: false),
      growable: false,
    );
  }

  int _getLastKeyY(Iterable<MapEntry<CellCoords, KeyboardKey>> keyEntries) {
    final MapEntry<CellCoords, KeyboardKey> lastKeyEntry = keyEntries.last;
    final CellCoords lastKey = lastKeyEntry.key;

    return lastKey.y;
  }

  void _setKey(MapEntry<CellCoords, KeyboardKey> entry) {
    final CellCoords key = entry.key;
    final KeyboardKey value = entry.value;
    final int y = key.y;
    final int x = key.x;

    keys[y][x] = value;
  }

  int _getMaxX(Iterable<MapEntry<CellCoords, KeyboardKey>> keyEntries) {
    final List<int> xValues = keyEntries.map((MapEntry<CellCoords, KeyboardKey> entry) => entry.key.x).toList();

    return xValues.max;
  }
}
