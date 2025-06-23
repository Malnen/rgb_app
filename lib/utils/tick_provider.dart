import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rgb_app/utils/type_defs.dart';

class TickProvider {
  static const int fps = 60;
  static const int frameTime = 1000 ~/ fps;
  static const double fpsMultiplier = 60 / fps;

  final ValueNotifier<int> averageFps;

  final List<FutureVoidCallback> _listeners;
  bool _processingFrame;
  int _frameCount = 0;
  DateTime _fpsTime;

  TickProvider()
      : averageFps = ValueNotifier<int>(0),
        _listeners = <FutureVoidCallback>[],
        _processingFrame = false,
        _fpsTime = DateTime.now() {
    Timer.periodic(
      Duration(milliseconds: frameTime),
      (_) => _processCallbacks(),
    );
  }

  void onTick(FutureVoidCallback callback) => _listeners.add(callback);

  void removeOnTick(FutureVoidCallback onTick) => _listeners.remove(onTick);

  Future<void> _processCallbacks() async {
    if (!_processingFrame) {
      _processingFrame = true;
      for (FutureVoidCallback callback in _listeners) {
        await callback();
      }

      _processingFrame = false;
      _frameCount++;
      final DateTime now = DateTime.now();
      if (now.millisecondsSinceEpoch >= _fpsTime.millisecondsSinceEpoch + 1000) {
        averageFps.value = _frameCount;
        _frameCount = 0;
        _fpsTime = DateTime.now();
      }
    }
  }
}
