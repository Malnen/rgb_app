import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k70_packet_filler.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k70_tester.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k_70_key_dictionary.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/enums/key_code.dart';
import 'package:rgb_app/extensions/int_iterable_extension.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

import '../device.dart';
import 'corsair_k_70_key.dart';
import 'corsair_k_70_packets.dart';

class CorsairK70 extends DeviceInterface {
  late CorsairK70Tester tester;

  final KeyBloc? keyBloc;

  CorsairK70({
    required Device device,
    this.keyBloc,
  }) : super(device: device);

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
  late CorsairK70PacketManager packetManager;

  List<List<CorsairK70Key>> keys = [];

  @override
  void init() {
    _setKeys();
    tester = CorsairK70Tester(
      corsairK70: this,
      keyBloc: keyBloc,
    );
    libusb.libusb_init(nullptr);
    devHandle = libusb.libusb_open_device_with_vid_pid(
      nullptr,
      int.parse('0x${device.vendorId}'),
      int.parse('0x${device.productId}'),
    );

    libusb.libusb_claim_interface(devHandle, 1);
    libusb.libusb_set_configuration(devHandle, 1);
    packetManager = CorsairK70PacketManager(this);
    packetManager.fill();
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
    } catch (e) {
      print(offsetX.toString() +
          ', ' +
          offsetY.toString() +
          ' out of range ' +
          device.deviceProductVendor.name);
    }
    sendData();
  }

  void _updateKeys() {
    for (int i = 0; i < keys.length; i++) {
      final List<CorsairK70Key> keys = this.keys[i];
      _updateKeyRow(keys, i);
    }
  }

  void _updateKeyRow(List<CorsairK70Key> keys, int i) {
    for (int j = 0; j < keys.length; j++) {
      final CorsairK70Key key = keys[j];
      if (key.keyCode == KeyCode.unknown) continue;

      _updateKey(key, i, j);
    }
  }

  void _updateKey(CorsairK70Key key, int i, int j) {
    final int packetIndex = key.packetIndex;
    final int index = key.index;
    final Color color = effectBloc.colors[i][j];
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
    final Map<String, CorsairK70Key> keys = CorsairK70KeyDictionary.keys;
    final Iterable<MapEntry<String, CorsairK70Key>> keyEntries = keys.entries;
    _setMinMax(keyEntries);
    _setKeysDimensions(keyEntries);
    for (MapEntry<String, CorsairK70Key> entry in keyEntries) {
      _setKey(entry);
    }
  }

  void _setMinMax(Iterable<MapEntry<String, CorsairK70Key>> keyEntries) {
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
    ));
    effectBloc.add(event);
  }

  void _setKeysDimensions(
      Iterable<MapEntry<String, CorsairK70Key>> keyEntries) {
    final int lastY = _getLastKeyY(keyEntries);
    final int maxX = _getMaxX(keyEntries);

    keys = List.generate(
        lastY + 1,
        (_) => List.generate(maxX + 1, (_) => CorsairK70KeyDictionary.emptyKey,
            growable: false),
        growable: false);
  }

  int _getLastKeyY(Iterable<MapEntry<String, CorsairK70Key>> keyEntries) {
    final MapEntry<String, CorsairK70Key> lastKeyEntry = keyEntries.last;
    final String lastKey = lastKeyEntry.key;

    return _getY(lastKey);
  }

  void _setKey(MapEntry<String, CorsairK70Key> entry) {
    final String key = entry.key;
    final CorsairK70Key value = entry.value;
    final int y = _getY(key);
    final int x = _getX(key);

    keys[y][x] = value;
  }

  int _getMaxX(Iterable<MapEntry<String, CorsairK70Key>> keyEntries) {
    final List<int> xValues = keyEntries
        .map((MapEntry<String, CorsairK70Key> entry) => _getX(entry.key))
        .toList();
    return xValues.max;
  }

  int _getX(String key) {
    final int indexOfX = key.indexOf('x');
    final int offset = indexOfX + 1;
    final int indexOfY = key.indexOf('y');
    final String x = key.substring(offset, indexOfY);

    return int.parse(x);
  }

  int _getY(String key) {
    final int indexOfY = key.indexOf('y');
    final int offset = indexOfY + 1;
    final String y = key.substring(offset);

    return int.parse(y);
  }
}
