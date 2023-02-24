import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/factories/property_factory.dart';
import 'package:rgb_app/models/colors_property.dart';
import 'package:rgb_app/models/effect_grid_data.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/models/vector_property.dart';

class SpiralEffect extends Effect {
  late NumericProperty speed;
  late NumericProperty twist;
  late VectorProperty center;
  late OptionProperty spinDirectionProperty;
  late OptionProperty twistDirectionProperty;
  late OptionProperty colorModeProperty;
  late ColorsProperty customColorsProperty;
  late List<List<Color>> _colors;
  late List<List<Color>> _lastColors;
  late double valueMax;

  double value = 1;
  double spinDirection = 1;
  double twistDirection = 1;
  double rotation = 0;
  bool leftDirection = false;
  bool customColorsMode = false;

  @override
  List<Property<Object>> get properties => <Property<Object>>[
        speed,
        twist,
        spinDirectionProperty,
        twistDirectionProperty,
        colorModeProperty,
        if (customColorsMode) customColorsProperty,
        center,
      ];

  List<Color> get customColors => customColorsProperty.value;

  int get customColorsLength => customColors.length;

  SpiralEffect({required super.effectData}) {
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
      value: <Option>{
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
      name: 'Spin Direction',
    );
    twistDirectionProperty = OptionProperty(
      value: <Option>{
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
      name: 'Twist Direction',
    );
    colorModeProperty = OptionProperty(
      value: <Option>{
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
      name: 'Color Mode',
    );
    customColorsProperty = ColorsProperty(
      value: <Color>[
        Colors.white,
        Colors.black,
      ],
      name: 'Custom Colors',
    );
  }

  factory SpiralEffect.fromJson(Map<String, dynamic> json) {
    final SpiralEffect effect = SpiralEffect(
      effectData: EffectDictionary.spiralEffect.getWithNewKey(),
    );
    effect.speed = PropertyFactory.getProperty(json['speed'] as Map<String, dynamic>) as NumericProperty;
    effect.twist = PropertyFactory.getProperty(json['twist'] as Map<String, dynamic>) as NumericProperty;
    effect.center = PropertyFactory.getProperty(json['center'] as Map<String, dynamic>) as VectorProperty;
    effect.spinDirectionProperty =
        PropertyFactory.getProperty(json['spinDirection'] as Map<String, dynamic>) as OptionProperty;
    effect.twistDirectionProperty =
        PropertyFactory.getProperty(json['twistDirection'] as Map<String, dynamic>) as OptionProperty;
    effect.colorModeProperty = PropertyFactory.getProperty(json['colorMode'] as Map<String, dynamic>) as OptionProperty;
    effect.customColorsProperty =
        PropertyFactory.getProperty(json['customColors'] as Map<String, dynamic>) as ColorsProperty;

    return effect;
  }

  @override
  void init() {
    _colors = <List<Color>>[];
    _fillColors();
    effectBloc.stream.listen(_effectGridListener);
    twist.onChanged = (_) => _fillWithProperValues();
    center.onChanged = (_) => _fillWithProperValues();
    spinDirectionProperty.onChanged = _onSpinDirectionChange;
    _onSpinDirectionChange(spinDirectionProperty.value);
    twistDirectionProperty.onChanged = _onTwistDirectionChange;
    _onTwistDirectionChange(twistDirectionProperty.value);
    colorModeProperty.onChanged = _onColorModeChange;
    _onColorModeChange(colorModeProperty.value);
    customColorsProperty.onChanged = _onCustomColorChange;
    _onCustomColorChange(customColorsProperty.value);
  }

  @override
  Map<String, dynamic> getData() {
    return <String, Object>{
      'twist': twist.toJson(),
      'speed': speed.toJson(),
      'center': center.toJson(),
      'spinDirection': spinDirectionProperty.toJson(),
      'twistDirection': twistDirectionProperty.toJson(),
      'colorMode': colorModeProperty.toJson(),
      'customColors': customColorsProperty.toJson(),
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

    _updateValue();
  }

  void _updateValue() {
    value += speed.value * spinDirection;
    if (value < 0 || value > valueMax) {
      value = value % valueMax;
      if (customColorsMode) {
        rotation += (speed.value * spinDirection) / 100;
        rotation %= 100;
        _fillWithProperValues();
      }
    }
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
    final List<List<Color>> newColors = <List<Color>>[];
    for (int i = 0; i < effectBloc.sizeY; i++) {
      final List<Color> rows = <Color>[];
      for (int j = 0; j < effectBloc.sizeX; j++) {
        rows.add(Colors.black);
      }
      newColors.add(rows);
    }

    _colors = newColors;
  }

  void _fillWithProperValues() {
    _lastColors = _colors.map(List<Color>.from).toList();
    final int height = _colors.length;
    final int width = _colors[0].length;
    final double centerX = center.value.x * width;
    final double centerY = center.value.y * height;

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final double distanceFromCenter = sqrt(pow(x - centerX, 2) + pow(y - centerY, 2));
        final double twistFactor = distanceFromCenter * twist.value;
        final double angle = atan2(y - centerY, x - centerX) + twistFactor * twistDirection + rotation;
        final double hue = _getHue(angle);
        if (customColorsMode) {
          _calculateCustomColor(hue, y, x);
        } else {
          _colors[y][x] = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
        }
      }
    }
  }

  double _getHue(double angle) {
    final double hue = (angle + pi) / (pi * 2);
    final double correctHue = customColorsMode ? hue * customColorsLength : hue * 360;

    return correctHue % 360;
  }

  void _calculateCustomColor(double hue, int y, int x) {
    final int firstColor = hue.floor() % customColorsLength;
    final int secondColor = (firstColor + 1) % customColorsLength;
    final double fraction = hue % 1;
    _colors[y][x] = Color.lerp(
      customColors[firstColor],
      customColors[secondColor],
      fraction,
    )!;
  }

  void _onSpinDirectionChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option option) => option.selected);
    spinDirection = selectedOption.value == 0 ? 1 : -1;
    leftDirection = selectedOption.value == 0;
  }

  void _onTwistDirectionChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option option) => option.selected);
    twistDirection = selectedOption.value == 0 ? 1 : -1;
    _fillWithProperValues();
  }

  void _onColorModeChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option option) => option.selected);
    customColorsMode = selectedOption.value == 0;
    valueMax = customColorsMode ? speed.max : 360;

    _fillWithProperValues();
  }

  void _onCustomColorChange(List<Color> value) {
    _fillWithProperValues();
  }

  void _setColors(int i, int j, List<List<Color>> colors) {
    if (customColorsMode) {
      final Color firstColor = leftDirection ? _lastColors[i][j] : _colors[i][j];
      final Color secondColor = leftDirection ? _colors[i][j] : _lastColors[i][j];
      colors[i][j] = Color.lerp(firstColor, secondColor, value / valueMax)!;
    } else {
      _setRainbowColor(i, j, colors);
    }
  }

  void _setRainbowColor(int i, int j, List<List<Color>> colors) {
    final Color color = _colors[i][j];
    final HSVColor hsv = HSVColor.fromColor(color);
    final double hue = hsv.hue;
    final double currentValue = hue + value;
    final double newHue = currentValue % 360;
    final HSVColor newHsv = HSVColor.fromAHSV(1, newHue, 1, 1);
    colors[i][j] = newHsv.toColor();
  }
}
