import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rgb_app/utils/tick_provider.dart';
import 'package:rgb_app/utils/type_defs.dart';

mixin FrameThrottler {
  int _lastExecution = 0;
  bool _running = false;

  @protected
  Future<void> runThrottled(FutureVoidCallback action) async {
    try {
      if (!_running) {
        _running = true;
        final int now = DateTime.now().millisecondsSinceEpoch;
        final int elapsed = now - _lastExecution;
        if (elapsed < TickProvider.frameTime) {
          await Future<void>.delayed(Duration(milliseconds: TickProvider.frameTime - elapsed));
        }

        _lastExecution = DateTime.now().millisecondsSinceEpoch;

        try {
          await action();
        } finally {
          _running = false;
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
