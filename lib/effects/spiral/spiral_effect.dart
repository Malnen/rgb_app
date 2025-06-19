import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/spiral/sprial_effect_properties.dart';
import 'package:rgb_app/models/option.dart';

class SpiralEffect extends Effect with SpiralEffectProperties {
  static const String className = 'SpiralEffect';
  static const String name = 'SpiralEffect';
  late List<List<Color>> _colors;
  late List<List<Color>> _lastColors;
  late double valueMax;

  double value = 1;
  double spinDirection = 1;
  double twistDirection = 1;
  double rotation = 0;
  bool leftDirection = false;
  bool customColorsMode = false;

  List<Color> get customColors => customColorsProperty.value;

  int get customColorsLength => customColors.length;

  SpiralEffect(super.effectData) : _colors = <List<Color>>[] {
    initProperties();
  }

  @override
  void init() {
    _fillColors();
    effectBloc.stream.listen(_effectGridListener);
    twist.addListener(_fillWithProperValues);
    center.addListener(_fillWithProperValues);
    spinDirectionProperty.addValueChangeListener(_onSpinDirectionChange);
    twistDirectionProperty.addValueChangeListener(_onTwistDirectionChange);
    colorModeProperty.addValueChangeListener(_onColorModeChange);
    customColorsProperty.addValueChangeListener(_onCustomColorChange);
    super.init();
  }

  @override
  void update() {
    if (colors.isEmpty) {
      return;
    }

    processUsedIndexes(_setColors);
    _updateValue();
  }

  void _updateValue() {
    value += speed.adjustedValue * spinDirection;
    if (value < 0 || value > valueMax) {
      value = value % valueMax;
      if (customColorsMode) {
        rotation += (speed.adjustedValue * spinDirection) / 100;
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
    for (int i = 0; i < effectBloc.sizeX; i++) {
      final List<Color> rows = <Color>[];
      for (int j = 0; j < effectBloc.sizeZ; j++) {
        rows.add(Colors.black);
      }
      newColors.add(rows);
    }

    _colors = newColors;
  }

  void _fillWithProperValues() {
    _lastColors = _colors.map(List<Color>.from).toList();
    final int height = colors.height;
    final int width = colors.width;
    final double centerX = center.value.x * width;
    final double centerY = center.value.y * height;

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final double distanceFromCenter = sqrt(pow(x - centerX, 2) + pow(y - centerY, 2));
        final double twistFactor = distanceFromCenter * twist.value;
        final double angle = atan2(x - centerX, y - centerY) + twistFactor * twistDirection + rotation;
        final double hue = _getHue(angle);
        if (customColorsMode) {
          _calculateCustomColor(hue, x, y);
        } else {
          _colors[x][y] = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
        }
      }
    }
  }

  double _getHue(double angle) {
    final double hue = (angle + pi) / (pi * 2);
    final double correctHue = customColorsMode ? hue * customColorsLength : hue * 360;

    return correctHue % 360;
  }

  void _calculateCustomColor(double hue, int x, int y) {
    final int firstColor = hue.floor() % customColorsLength;
    final int secondColor = (firstColor + 1) % customColorsLength;
    final double fraction = hue % 1;
    _colors[x][y] = Color.lerp(
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
    customColorsProperty.visible = customColorsMode;

    _fillWithProperValues();
  }

  void _onCustomColorChange(List<Color> value) {
    _fillWithProperValues();
  }

  void _setColors(int x, int y) {
    if (customColorsMode) {
      final Color firstColor = leftDirection ? _lastColors[x][y] : _colors[x][y];
      final Color secondColor = leftDirection ? _colors[x][y] : _lastColors[x][y];
      colors.setColor(x, y, Color.lerp(firstColor, secondColor, value / valueMax)!);
    } else {
      _setRainbowColor(x, y);
    }
  }

  void _setRainbowColor(int x, int y) {
    final Color color = _colors[x][y];
    final HSVColor hsv = HSVColor.fromColor(color);
    final double hue = hsv.hue;
    final double currentValue = hue + value;
    final double newHue = currentValue % 360;
    final HSVColor newHsv = HSVColor.fromAHSV(1, newHue, 1, 1);
    colors.setColor(x, y, newHsv.toColor());
  }
}
