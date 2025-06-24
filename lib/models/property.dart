import 'dart:async';

import 'package:flutter/material.dart';

abstract class Property<T> extends ValueNotifier<T> {
  final String name;
  final String idn;
  final int _debounceDuration;

  bool visible;

  T _rawValue;
  Timer? _debounce;

  bool _debounceEnabled = false;

  Property({
    required this.name,
    required this.idn,
    required T initialValue,
    this.visible = true,
    int debounceDuration = 4,
  })  : _debounceDuration = debounceDuration,
        _rawValue = initialValue,
        super(initialValue);

  @override
  T get value => _rawValue;

  @override
  set value(T newValue) {
    _rawValue = newValue;
    if (_debounceEnabled) {
      _debounce?.cancel();
      _debounce = Timer(Duration(milliseconds: _debounceDuration), _applyDebouncedValue);
    } else {
      _applyDebouncedValue();
    }
  }

  void enableDebounce() {
    _debounceEnabled = true;
  }

  void disableDebounce() {
    _debounceEnabled = false;
  }

  Map<String, Object> getData();

  void addValueChangeListener(void Function(T) onChange) {
    addListener(() => onChange(value));
  }

  void notify() => notifyListeners();

  void updateProperty(covariant Property<T> property) {
    value = property.value;
    visible = property.visible;
  }

  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{
      'value': value,
      'name': name,
      'idn': idn,
      'type': runtimeType.toString(),
    };
    final Map<String, Object?> data = getData();
    json.addAll(data);

    return json;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _applyDebouncedValue() {
    if (super.value != _rawValue) {
      super.value = _rawValue;
    }
  }
}
