import 'package:flutter/cupertino.dart';

abstract class Property<T> extends ValueNotifier<T> {
  final String name;

  Property({
    required this.name,
    required T initialValue,
  }) : super(initialValue);

  Map<String, Object> getData();

  void addValueChangeListener(void Function(T) onChange) {
    addListener(() => onChange(value));
  }

  void notify() {
    notifyListeners();
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
