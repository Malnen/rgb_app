import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/devices/steel_series_rival_100/steel_series_rival_100.dart';
import 'package:rgb_app/testers/device_tester.dart';

class SteelSeriesRival100Tester extends DeviceTester {
  final List<Timer> timers = <Timer>[];
  final SteelSeriesRival100 steelSeriesRival100;

  double value = 0;
  bool inc = true;

  SteelSeriesRival100Tester({
    required this.steelSeriesRival100,
  });

  @override
  void test() {
    steelSeriesRival100.color = Color.fromARGB(1, 255, 255, 255);
    devicesBloc.add(SendDataManuallyEvent(steelSeriesRival100));
  }

  @override
  void blink() {
    _updateColor(Duration(milliseconds: 4), 0.75);
    final Timer timer = Timer.periodic(
      Duration(milliseconds: 100),
      (Timer timer) {
        steelSeriesRival100.color = Color.fromARGB(1, value.toInt(), value.toInt(), value.toInt());
        devicesBloc.add(SendDataManuallyEvent(steelSeriesRival100));
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
