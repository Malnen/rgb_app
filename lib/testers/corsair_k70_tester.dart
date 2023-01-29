import 'dart:async';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/cell_coords.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_state_type.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k_70.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k_70_packets.dart';
import 'package:rgb_app/devices/key_dictionary.dart';
import 'package:rgb_app/devices/keyboard_key.dart';
import 'package:rgb_app/enums/key_code.dart';
import 'package:rgb_app/testers/device_tester.dart';

class CorsairK70Tester implements DeviceTester {
  final List<Timer> timers = <Timer>[];
  final CorsairK70 corsairK70;
  final KeyBloc keyBloc;

  int currentPacketIndex = 0;
  int currentIndex = 0;
  double value = 0;
  bool inc = true;

  late int lastValueR;
  late int lastValueG;
  late int lastValueB;

  int get length => corsairK70.dataPkt1.length;

  CorsairK70Tester({
    required this.corsairK70,
  }) : keyBloc = GetIt.instance.get();

  @override
  Future<void> test() async {
    _rememberValues();
    keyBloc.stream.listen((KeyState state) {
      if (state.type == KeyStateType.released) {
        _onKeyReleased(state);
      }
    });
    await _sendData();
  }

  @override
  Future<void> blink() async {
    final Iterable<MapEntry<CellCoords, KeyboardKey>> entries = KeyDictionary.keys.entries;
    _updateColor(Duration(milliseconds: 4), 0.75);
    final Timer timer = Timer.periodic(
      Duration(milliseconds: 100),
          (Timer timer) {
        _blink(entries);
        corsairK70.sendData();
      },
    );
    timers.add(timer);
  }

  @override
  void dispose() {
    for (Timer timer in timers) {
      timer.cancel();
    }
  }

  void _blink(Iterable<MapEntry<CellCoords, KeyboardKey>> entries) {
    for (MapEntry<CellCoords, KeyboardKey> entry in entries) {
      final KeyboardKey key = entry.value;
      final int packetIndex = key.packetIndex;
      if (packetIndex < 0) continue;
      _setBlinkColor(packetIndex, key);
    }
    corsairK70.sendData();
  }

  void _setBlinkColor(int packetIndex, KeyboardKey key) {
    final CorsairK70Packets packets = corsairK70.getPacket(packetIndex);
    final Uint8List rPkt = packets.rPkt;
    final Uint8List gPkt = packets.gPkt;
    final Uint8List bPkt = packets.bPkt;
    rPkt[key.index] = value.toInt();
    gPkt[key.index] = value.toInt();
    bPkt[key.index] = value.toInt();
  }

  void _rememberValues() {
    if (currentPacketIndex == 0) {
      lastValueR = corsairK70.rPkt1[currentIndex];
      lastValueG = corsairK70.gPkt1[currentIndex];
      lastValueB = corsairK70.bPkt1[currentIndex];
    } else if (currentPacketIndex == 1) {
      lastValueR = corsairK70.rPkt2[currentIndex];
      lastValueG = corsairK70.gPkt2[currentIndex];
      lastValueB = corsairK70.bPkt2[currentIndex];
    } else if (currentPacketIndex == 2) {
      lastValueR = corsairK70.rPkt3[currentIndex];
      lastValueG = corsairK70.gPkt3[currentIndex];
      lastValueB = corsairK70.bPkt3[currentIndex];
    }
  }

  void _onKeyReleased(KeyState state) {
    if (state.keyName == KeyCodeExtension.name(KeyCode.esc.keyCode)) {
      _next();
    }

    print('${state.keyCode} - ${state.keyName}');
    print('currentIndex - $currentIndex');
    print('currentPacketIndex - $currentPacketIndex');
  }

  void _next() {
    _setCurrentIndexValue(
      valueR: lastValueR,
      valueG: lastValueG,
      valueB: lastValueB,
    );
    currentIndex++;
    if (currentIndex >= length) {
      currentIndex = 0;
      currentPacketIndex++;
      if (currentPacketIndex > 2) {
        return;
      }
    }
    _rememberValues();
  }

  Future<void> _sendData() async {
    _updateColor();
    final Timer timer = Timer.periodic(
      Duration(milliseconds: 100),
          (Timer timer) {
        _setCurrentIndexValue(
          valueR: value.toInt(),
          valueG: 0,
          valueB: 0,
        );
        corsairK70.sendData();
      },
    );
    timers.add(timer);
  }

  void _updateColor([final Duration? duration, double? speed]) {
    final double updateSpeed = speed ?? 5;
    final Timer timer = Timer.periodic(
      duration ?? Duration(microseconds: 2000),
      (Timer timer) {
        if (inc) {
          value += updateSpeed;
        } else {
          value -= updateSpeed;
        }

        if (value >= 255) {
          inc = false;
          value = 255;
        }
        if (value <= 0) {
          inc = true;
          value = 0;
        }
      },
    );
    timers.add(timer);
  }

  void _setCurrentIndexValue({
    required int valueR,
    required int valueG,
    required int valueB,
  }) {
    if (currentPacketIndex == 0) {
      corsairK70.rPkt1[currentIndex] = valueR;
      corsairK70.gPkt1[currentIndex] = valueG;
      corsairK70.bPkt1[currentIndex] = valueB;
    } else if (currentPacketIndex == 1) {
      corsairK70.rPkt2[currentIndex] = valueR;
      corsairK70.gPkt2[currentIndex] = valueG;
      corsairK70.bPkt2[currentIndex] = valueB;
    } else if (currentPacketIndex == 2) {
      corsairK70.rPkt3[currentIndex] = valueR;
      corsairK70.gPkt3[currentIndex] = valueG;
      corsairK70.bPkt3[currentIndex] = valueB;
    }
  }
}
