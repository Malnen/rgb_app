import 'package:flutter/material.dart';
import 'package:rgb_app/models/color_list_property.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/models/vector_property.dart';

mixin SpiralEffectProperties {
  List<Property<Object>> get properties => <Property<Object>>[
        speed,
        twist,
        spinDirectionProperty,
        twistDirectionProperty,
        colorModeProperty,
        customColorsProperty,
        center,
      ];

  late NumericProperty speed;
  late NumericProperty twist;
  late VectorProperty center;
  late OptionProperty spinDirectionProperty;
  late OptionProperty twistDirectionProperty;
  late OptionProperty colorModeProperty;
  late ColorListProperty customColorsProperty;

  @protected
  void initProperties() {
    speed = NumericProperty(
      initialValue: 5,
      name: 'Speed',
      idn: 'speed',
      min: 1,
      max: 20,
    );
    twist = NumericProperty(
      initialValue: 0,
      name: 'Twist',
      idn: 'twist',
      min: 0,
      max: 1,
    );
    center = VectorProperty(
      initialValue: Vector(x: 0.5, y: 0.5),
      name: 'Center',
      idn: 'center',
    );
    spinDirectionProperty = OptionProperty(
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
      idn: 'spinDirection',
      name: 'Spin Direction',
    );
    twistDirectionProperty = OptionProperty(
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
      idn: 'twistDirection',
      name: 'Twist Direction',
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
