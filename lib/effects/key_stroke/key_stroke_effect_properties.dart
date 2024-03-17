import 'package:flutter/material.dart';
import 'package:rgb_app/models/color_list_property.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/property.dart';

mixin KeyStrokeEffectProperties {
  List<Property<Object>> get properties => <Property<Object>>[
        duration,
        expansion,
        fadeSpeed,
        colorsProperty,
      ];

  late NumericProperty duration;
  late NumericProperty expansion;
  late NumericProperty fadeSpeed;
  late ColorListProperty colorsProperty;

  @protected
  void initProperties() {
    duration = NumericProperty(
      min: 1,
      max: 10,
      name: 'Duration',
      idn: 'duration',
      initialValue: 4,
    );
    expansion = NumericProperty(
      min: 0.01,
      max: 1.5,
      name: 'Expansion',
      idn: 'expansion',
      initialValue: 0.75,
    );
    fadeSpeed = NumericProperty(
      min: 0.01,
      max: 0.5,
      name: 'Fade Speed',
      idn: 'fadeSpeed',
      initialValue: 0.15,
    );
    colorsProperty = ColorListProperty(
      initialValue: <Color>[
        Colors.white,
        Colors.black,
      ],
      idn: 'colors',
      name: 'Colors',
    );
  }
}
