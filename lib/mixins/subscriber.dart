import 'dart:async';

import 'package:flutter/foundation.dart';

mixin Subscriber {
  final List<StreamSubscription<Object?>> _subscriptions = <StreamSubscription<Object?>>[];

  @protected
  void subscribe(StreamSubscription<Object?> subscription) => _subscriptions.add(subscription);

  @protected
  void unsubscribe() {
    for (StreamSubscription<Object?> subscription in _subscriptions) {
      subscription.cancel();
    }
  }
}
