import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

LoadingService get loadingService => GetIt.instance.get();

class LoadingService {
  final ValueNotifier<bool> _isLoading;

  int _pendingLoadings;

  LoadingService()
      : _isLoading = ValueNotifier<bool>(false),
        _pendingLoadings = 0;

  ValueNotifier<bool> get isLoading => _isLoading;

  void showLoading() {
    _isLoading.value = true;
    _pendingLoadings++;
  }

  void hideLoading() {
    _pendingLoadings--;
    if (_pendingLoadings <= 0) {
      _isLoading.value = false;
      _pendingLoadings = 0;
    }
  }
}
