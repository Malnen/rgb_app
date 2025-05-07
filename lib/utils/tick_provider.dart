import 'dart:async';

import 'package:rgb_app/utils/type_defs.dart';

class TickProvider {
  static const int fps = 60;
  static const int frameTime = 1000 ~/ fps;
  static const double fpsMultiplier = 60 / fps;

  final List<FutureVoidCallback> _listeners;

  bool _processingFrame;

  TickProvider()
      : _listeners = <FutureVoidCallback>[],
        _processingFrame = false {
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
    }
  }
}
