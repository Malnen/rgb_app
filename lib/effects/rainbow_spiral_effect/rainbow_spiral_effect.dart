import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/factories/property_factory.dart';
import 'package:rgb_app/models/effect_grid_data.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/options.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/models/vector_property.dart';

class RainbowSpiralEffect extends Effect {
  late Property<double> speed;
  late Property<double> twist;
  late Property<Vector> center;
  late Property<Options> spinDirectionProperty;
  late Property<Options> twistDirectionProperty;
  late List<List<int>> _colors;
  double value = 1;
  double spinDirection = 1;
  double twistDirection = 1;

  @override
  List<Property<Object>> get properties => <Property<Object>>[
        speed,
        twist,
        spinDirectionProperty,
        twistDirectionProperty,
        center,
      ];

  RainbowSpiralEffect({required super.effectData}) {
    speed = NumericProperty(
      value: 2.5,
      name: 'Speed',
      min: 1,
      max: 20,
    );
    twist = NumericProperty(
      value: 0,
      name: 'Twist',
      min: 0,
      max: 1,
      onChanged: (_) => _fillWithProperValues(),
    );
    center = VectorProperty(
      value: Vector(x: 0.5, y: 0.5),
      name: 'Center',
      onChanged: (_) => _fillWithProperValues(),
    );
    spinDirectionProperty = OptionProperty(
      value: Options(
        <Option>{
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
      ),
      name: 'Spin Direction',
    );
    twistDirectionProperty = OptionProperty(
      value: Options(
        <Option>{
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
      ),
      name: 'Twist Direction',
    );
  }

  factory RainbowSpiralEffect.fromJson(Map<String, dynamic> json) {
    final RainbowSpiralEffect effect = RainbowSpiralEffect(
      effectData: EffectDictionary.rainbowSpiralEffect.getWithNewKey(),
    );
    effect.speed = PropertyFactory.getProperty(json['speed'] as Map<String, dynamic>) as NumericProperty;
    effect.twist = PropertyFactory.getProperty(json['twist'] as Map<String, dynamic>) as NumericProperty;
    effect.center = PropertyFactory.getProperty(json['center'] as Map<String, dynamic>) as VectorProperty;
    effect.spinDirectionProperty =
        PropertyFactory.getProperty(json['spinDirection'] as Map<String, dynamic>) as OptionProperty;
    effect.twistDirectionProperty =
        PropertyFactory.getProperty(json['twistDirection'] as Map<String, dynamic>) as OptionProperty;

    return effect;
  }

  @override
  void init() {
    _colors = <List<int>>[];
    _fillColors();
    effectBloc.stream.listen(_effectGridListener);
    twist.onChanged = (_) => _fillWithProperValues();
    center.onChanged = (_) => _fillWithProperValues();
    spinDirectionProperty.onChanged = _onSpinDirectionChange;
    _onSpinDirectionChange(spinDirectionProperty.value);
    twistDirectionProperty.onChanged = _onTwistDirectionChange;
    _onTwistDirectionChange(twistDirectionProperty.value);
  }

  @override
  Map<String, dynamic> getData() {
    return <String, Object>{
      'twist': twist.toJson(),
      'speed': speed.toJson(),
      'center': center.toJson(),
      'spinDirection': spinDirectionProperty.toJson(),
      'twistDirection': twistDirectionProperty.toJson(),
    };
  }

  @override
  void update() {
    final EffectState state = effectBloc.state;
    final EffectGridData effectGridData = state.effectGridData;
    final List<List<Color>> colors = effectGridData.colors;
    for (int i = 0; i < effectBloc.sizeY; i++) {
      for (int j = 0; j < effectBloc.sizeX; j++) {
        _setColors(i, j, colors);
      }
    }

    value += speed.value * spinDirection;
    value = value % 360;
  }

  void _effectGridListener(EffectState state) {
    if (state.sizeChanged) {
      _fillColors();
    }
  }

  void _fillColors() {
    _prepareNewColors();
    _fillWithProperValues();
  }

  void _prepareNewColors() {
    final List<List<int>> newColors = <List<int>>[];
    for (int i = 0; i < effectBloc.sizeY; i++) {
      final List<int> rows = <int>[];
      for (int j = 0; j < effectBloc.sizeX; j++) {
        rows.add(0);
      }
      newColors.add(rows);
    }

    _colors = newColors;
  }

  void _fillWithProperValues() {
    final int height = _colors.length;
    final int width = _colors[0].length;
    final double centerX = center.value.x * width;
    final double centerY = center.value.y * height;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final double distanceFromCenter = sqrt(pow(x - centerX, 2) + pow(y - centerY, 2));
        final double twistFactor = distanceFromCenter * twist.value;
        final double angle = atan2(y - centerY, x - centerX) + twistFactor * twistDirection;
        final double hue = (angle + pi) / (pi * 2) * 360;
        _colors[y][x] = hue.toInt();
      }
    }
  }

  void _onSpinDirectionChange(Options options) {
    final Option selectedOption = options.options.firstWhere((Option option) => option.selected);
    spinDirection = selectedOption.value == 0 ? 1 : -1;
  }

  void _onTwistDirectionChange(Options options) {
    final Option selectedOption = options.options.firstWhere((Option option) => option.selected);
    twistDirection = selectedOption.value == 0 ? 1 : -1;
    _fillWithProperValues();
  }

  void _setColors(int i, int j, List<List<Color>> colors) {
    final double colorValue = _colors[i][j].toDouble();
    final double currentValue = colorValue + value;
    final double hue = currentValue % 360;
    final HSVColor hsv = HSVColor.fromAHSV(1, hue, 1, 1);
    colors[i][j] = hsv.toColor();
  }
}
