import 'package:flutter/material.dart';
import 'package:rgb_app/models/color_list_property.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/models/property.dart';

mixin WaveEffectProperties {
  List<Property<Object>> get properties => <Property<Object>>[
        size,
        speed,
        waveDirection,
        colorModeProperty,
        customColorsProperty,
      ];

  late NumericProperty size;
  late NumericProperty speed;
  late Property<Set<Option>> waveDirection;
  late Property<Set<Option>> colorModeProperty;
  late ColorListProperty customColorsProperty;

  @protected
  void initProperties() {
    size = NumericProperty(
      initialValue: 15,
      name: 'Size',
      idn: 'size',
      min: 1,
      max: 20,
    );
    speed = NumericProperty(
      initialValue: 2.5,
      name: 'Speed',
      idn: 'speed',
      min: 1,
      max: 20,
    );
    waveDirection = OptionProperty(
      initialValue: <Option>{
        Option(
          value: 0,
          name: 'Left',
          selected: false,
        ),
        Option(
          value: 1,
          name: 'Right',
          selected: true,
        ),
      },
      idn: 'waveDirection',
      name: 'Wave Direction',
    );
    colorModeProperty = OptionProperty(
      initialValue: <Option>{
        Option(
          value: 0,
          name: 'Custom',
          selected: false,
        ),
        Option(
          value: 1,
          name: 'Rainbow',
          selected: true,
        ),
      },
      idn: 'colorMode',
      name: 'Color Mode',
    );
    customColorsProperty = ColorListProperty(
      initialValue: <Color>[
        Colors.white,
        Colors.black,
      ],
      idn: 'customColors',
      name: 'Custom Colors',
    );
  }
}
