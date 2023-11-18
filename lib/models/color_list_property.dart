import 'package:flutter/material.dart';
import 'package:rgb_app/models/property.dart';

class ColorListProperty extends Property<List<Color>> {
  ColorListProperty({
    required super.name,
    required super.idn,
    required super.initialValue,
  });

  @override
  Map<String, Object> getData() {
    return <String, Object>{
      'value': value.map((Color color) => color.value).toList(),
    };
  }
}
