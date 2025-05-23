import 'package:flutter/material.dart';
import 'package:rgb_app/models/property.dart';

class ColorProperty extends Property<Color> {
  ColorProperty({
    required super.name,
    required super.idn,
    required super.initialValue,
  });

  @override
  Map<String, Object> getData() => <String, Object>{
        'value': value.toARGB32(),
      };
}
