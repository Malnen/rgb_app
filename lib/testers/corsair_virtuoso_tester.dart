import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/devices/corsair_virtuoso/corsair_virtuoso.dart';
import 'package:rgb_app/testers/device_tester.dart';

class CorsairVirtuosoTester extends DeviceTester {
  final List<Timer> timers = <Timer>[];
  final CorsairVirtuoso corsairVirtuoso;

  CorsairVirtuosoTester({required this.corsairVirtuoso});

  @override
  void blink() {
    final Timer timer = Timer.periodic(
      Duration(milliseconds: 100),
      (Timer timer) {
        corsairVirtuoso.color = Color.fromARGB(1, 255, 0, 0);
        devicesBloc.add(SendDataManuallyEvent(corsairVirtuoso));
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

  @override
  void test() {
    // TODO: implement test
  }
}
