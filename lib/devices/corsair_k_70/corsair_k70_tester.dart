import 'dart:async';

import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_state.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k_70.dart';
import 'package:rgb_app/enums/key_code.dart';

class CorsairK70Tester {
  final CorsairK70 corsairK70;
  final KeyBloc? keyBloc;

  int currentPacketIndex = 0;
  int currentIndex = 0;
  int value = 0;
  bool inc = true;

  late int lastValueR;
  late int lastValueG;
  late int lastValueB;

  int get length => corsairK70.dataPkt1.length;

  CorsairK70Tester({
    required this.corsairK70,
    this.keyBloc,
  });

  Future<void> test() async {
    _rememberValues();
    keyBloc?.stream.listen((KeyState state) {
      if (state is KeyReleasedState) {
        _onKeyReleased(state);
      }
    });
    _sendData();
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

  void _onKeyReleased(KeyReleasedState state) {
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
    Timer.periodic(
      Duration(milliseconds: 100),
      (Timer timer) {
        _setCurrentIndexValue(
          valueR: value,
          valueG: 0,
          valueB: 0,
        );
        corsairK70.sendData();
      },
    );
  }

  void _updateColor() {
    final int speed = 5;
    Timer.periodic(
      Duration(microseconds: 2000),
      (Timer timer) {
        if (inc) {
          value += speed;
        } else {
          value -= speed;
        }

        if (value >= 255) {
          inc = false;
        }
        if (value <= 0) {
          inc = true;
        }
      },
    );
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
