import 'package:flutter/material.dart';
import 'package:rgb_app/models/property.dart';

class ColorsProperty extends Property<List<Color>> {
  ColorsProperty({
    required super.value,
    required super.name,
  });

  @override
  Map<String, Object> getData() {
    return <String, Object>{
      'value': value.map((Color color) => color.value).toList(),
    };
  }
}
