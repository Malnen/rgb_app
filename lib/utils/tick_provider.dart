import 'dart:async';

import 'package:flutter/foundation.dart';

class TickProvider {
  final List<VoidCallback> _listeners;

  TickProvider() : _listeners = <VoidCallback>[] {
    Timer.periodic(
      Duration(milliseconds: 25),
      (_) => _processCallbacks(),
    );
  }

  void onTick(VoidCallback callback) => _listeners.add(callback);

  void _processCallbacks() {
    for (VoidCallback callback in _listeners) {
      callback.call();
    }
  }
}
