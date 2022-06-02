import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rgb_app/devices/steel_series_rival_100.dart';

class SteelSeriesRival100Tester {
  final SteelSeriesRival100 steelSeriesRival100;

  int value = 0;
  bool inc = true;

  SteelSeriesRival100Tester({
    required this.steelSeriesRival100,
  });

  void test() {
    steelSeriesRival100.color = Color.fromARGB(1, 255, 255, 255);
    steelSeriesRival100.sendData();
  }

  void blink() {
    _updateColor(Duration(milliseconds: 2), 1);
    Timer.periodic(
      Duration(milliseconds: 100),
      (Timer timer) {
        steelSeriesRival100.color = Color.fromARGB(1, value, value, value);
        steelSeriesRival100.sendData();
      },
    );
  }

  void _updateColor([Duration? duration, int? speed]) {
    final int updateSpeed = speed ?? 5;
    Timer.periodic(
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
  }
}
