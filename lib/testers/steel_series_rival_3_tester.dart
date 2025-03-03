import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/devices/steel_series_rival_3/steel_series_rival_3.dart';
import 'package:rgb_app/testers/device_tester.dart';

class SteelSeriesRival3Tester extends DeviceTester {
  final List<Timer> timers = <Timer>[];
  final SteelSeriesRival3 steelSeriesRival3;

  double value = 0;
  bool inc = true;

  SteelSeriesRival3Tester({
    required this.steelSeriesRival3,
  });

  @override
  void test() {
    steelSeriesRival3.colors[0] = Color.fromARGB(1, 255, 0, 0);
    steelSeriesRival3.colors[1] = Color.fromARGB(1, 0, 255, 0);
    steelSeriesRival3.colors[2] = Color.fromARGB(1, 0, 0, 255);
    devicesBloc.add(SendDataManuallyEvent(steelSeriesRival3));
  }

  @override
  void blink() {
    _updateColor(Duration(milliseconds: 4), 0.75);
    final Timer timer = Timer.periodic(
      Duration(milliseconds: 25),
      (Timer timer) {
        final List<Color> newColors = <Color>[];
        for (int i = 0; i < steelSeriesRival3.colors.length; i++) {
          final Color newColor = Color.fromARGB(1, value.toInt(), value.toInt(), value.toInt());
          newColors.add(newColor);
        }
        steelSeriesRival3.colors = newColors;
        devicesBloc.add(SendDataManuallyEvent(steelSeriesRival3));
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

  @override
  void dispose() {
    for (Timer timer in timers) {
      timer.cancel();
    }
  }
}
