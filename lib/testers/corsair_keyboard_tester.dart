import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_state_type.dart';
import 'package:rgb_app/devices/corsair_keyboard/corsair_keyboard.dart';
import 'package:rgb_app/devices/corsair_keyboard/corsair_keyboard_packets.dart';
import 'package:rgb_app/devices/keyboard_key.dart';
import 'package:rgb_app/enums/key_code.dart';
import 'package:rgb_app/testers/device_tester.dart';
import 'package:vector_math/vector_math.dart';

class CorsairKeyboardTester extends DeviceTester {
  final List<Timer> timers = <Timer>[];
  final CorsairKeyboard corsairKeyboard;
  final KeyBloc keyBloc;

  int currentPacketIndex = 0;
  int currentIndex = 0;
  double value = 0;
  bool inc = true;

  late int lastValueR;
  late int lastValueG;
  late int lastValueB;

  int get length => corsairKeyboard.dataPkt1.length;

  CorsairKeyboardTester({
    required this.corsairKeyboard,
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
    final Iterable<MapEntry<Vector3, List<KeyboardKey>>> keyEntries = corsairKeyboard.keys.entries;
    _updateColor(Duration(milliseconds: 4), 0.75);
    final Timer periodicBlinkTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (Timer timer) {
        _blink(keyEntries);
        devicesBloc.add(SendDataManuallyEvent(corsairKeyboard));
      },
    );

    timers.add(periodicBlinkTimer);
  }

  @override
  void dispose() {
    for (Timer timer in timers) {
      timer.cancel();
    }
  }

  void _blink(Iterable<MapEntry<Vector3, List<KeyboardKey>>> keyEntries) {
    for (MapEntry<Vector3, List<KeyboardKey>> entry in keyEntries) {
      final List<KeyboardKey> keysAtPoint = entry.value;
      for (KeyboardKey key in keysAtPoint) {
        final int packetIndex = key.packetIndex;
        if (packetIndex < 0) {
          continue;
        }

        _setBlinkColor(packetIndex, key);
      }
    }

    devicesBloc.add(SendDataManuallyEvent(corsairKeyboard));
  }

  void _setBlinkColor(int packetIndex, KeyboardKey key) {
    final CorsairKeyboardPackets packets = corsairKeyboard.getPacket(packetIndex);
    final List<int> rPkt = packets.rPkt;
    final List<int> gPkt = packets.gPkt;
    final List<int> bPkt = packets.bPkt;
    rPkt[key.index] = value.toInt();
    gPkt[key.index] = value.toInt();
    bPkt[key.index] = value.toInt();
  }

  void _rememberValues() {
    if (currentPacketIndex == 0) {
      lastValueR = corsairKeyboard.rPkt1[currentIndex];
      lastValueG = corsairKeyboard.gPkt1[currentIndex];
      lastValueB = corsairKeyboard.bPkt1[currentIndex];
    } else if (currentPacketIndex == 1) {
      lastValueR = corsairKeyboard.rPkt2[currentIndex];
      lastValueG = corsairKeyboard.gPkt2[currentIndex];
      lastValueB = corsairKeyboard.bPkt2[currentIndex];
    } else if (currentPacketIndex == 2) {
      lastValueR = corsairKeyboard.rPkt3[currentIndex];
      lastValueG = corsairKeyboard.gPkt3[currentIndex];
      lastValueB = corsairKeyboard.bPkt3[currentIndex];
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
        devicesBloc.add(SendDataManuallyEvent(corsairKeyboard));
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
      corsairKeyboard.rPkt1[currentIndex] = valueR;
      corsairKeyboard.gPkt1[currentIndex] = valueG;
      corsairKeyboard.bPkt1[currentIndex] = valueB;
    } else if (currentPacketIndex == 1) {
      corsairKeyboard.rPkt2[currentIndex] = valueR;
      corsairKeyboard.gPkt2[currentIndex] = valueG;
      corsairKeyboard.bPkt2[currentIndex] = valueB;
    } else if (currentPacketIndex == 2) {
      corsairKeyboard.rPkt3[currentIndex] = valueR;
      corsairKeyboard.gPkt3[currentIndex] = valueG;
      corsairKeyboard.bPkt3[currentIndex] = valueB;
    }
  }
}
