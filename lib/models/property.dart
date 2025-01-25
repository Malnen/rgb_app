import 'package:flutter/material.dart';

abstract class Property<T> extends ValueNotifier<T> {
  final String name;
  final String idn;

  bool visible;

  Property({
    required this.name,
    required this.idn,
    required T initialValue,
    this.visible = true,
  }) : super(initialValue);

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
      'type': runtimeType.toString(),
    };
    final Map<String, Object?> data = getData();
    json.addAll(data);

    return json;
  }
}
