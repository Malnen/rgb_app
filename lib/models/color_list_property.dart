import 'package:flutter/material.dart';
import 'package:rgb_app/models/property.dart';

class ColorListProperty extends Property<List<Color>> {
  ColorListProperty({required super.value, required super.name});

  @override
  Map<String, Object> getData() {
    return <String, Object>{};
  }
}
