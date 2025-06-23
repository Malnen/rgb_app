import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/spiral/sprial_effect_properties.dart';
import 'package:rgb_app/models/option.dart';

class SpiralEffect extends Effect with SpiralEffectProperties {
  static const String className = 'SpiralEffect';
  static const String name = 'SpiralEffect';
  late List<List<List<Color>>> _colors;
  late List<List<List<Color>>> _lastColors;
  late double valueMax;

  double value = 1;
  double spinDirection = 1;
  double twistDirection = 1;
  double rotation = 0;
  bool leftDirection = false;
  bool customColorsMode = false;

  List<Color> get customColors => customColorsProperty.value;

  int get customColorsLength => customColors.length;

  SpiralEffect(super.effectData) : _colors = <List<List<Color>>>[] {
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
    if (colors.isEmpty) return;
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
    final List<List<List<Color>>> newColors = <List<List<Color>>>[];
    for (int x = 0; x < effectBloc.sizeX; x++) {
      final List<List<Color>> plane = <List<Color>>[];
      for (int y = 0; y < effectBloc.sizeY; y++) {
        final List<Color> row = <Color>[];
        for (int z = 0; z < effectBloc.sizeZ; z++) {
          row.add(Colors.black);
        }

        plane.add(row);
      }

      newColors.add(plane);
    }
    _colors = newColors;
  }

  void _fillWithProperValues() {
    _lastColors = _colors.map((List<List<Color>> plane) => plane.map(List<Color>.from).toList()).toList();
    final int width = colors.width;
    final int height = colors.height;
    final int depth = colors.depth;
    final double centerX = center.value.x * width;
    final double centerY = center.value.y * height;
    final double centerZ = center.value.z * depth;

    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        for (int z = 0; z < depth; z++) {
          final double dx = x - centerX;
          final double dy = y - centerY;
          final double dz = z - centerZ;
          final double distance = sqrt(dx * dx + dy * dy + dz * dz);
          if (distance == 0) continue;

          final double theta = atan2(dy, dx);
          final double phi = acos(dz / distance);
          final double twistFactor = distance * twist.value;
          final double angle = theta + phi + twistFactor * twistDirection + rotation;
          final double hue = _getHue(angle);

          if (customColorsMode) {
            _calculateCustomColor(hue, x, y, z);
          } else {
            _colors[x][y][z] = HSVColor.fromAHSV(1, hue, 1, 1).toColor();
          }
        }
      }
    }
  }

  double _getHue(double angle) {
    final double hue = (angle + pi) / (pi * 2);
    final double correctHue = customColorsMode ? hue * customColorsLength : hue * 360;
    return correctHue % 360;
  }

  void _calculateCustomColor(double hue, int x, int y, int z) {
    final int firstColor = hue.floor() % customColorsLength;
    final int secondColor = (firstColor + 1) % customColorsLength;
    final double fraction = hue % 1;
    _colors[x][y][z] = Color.lerp(
      customColors[firstColor],
      customColors[secondColor],
      fraction,
    )!;
  }

  void _onSpinDirectionChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option o) => o.selected);
    spinDirection = selectedOption.value == 0 ? 1 : -1;
    leftDirection = selectedOption.value == 0;
  }

  void _onTwistDirectionChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option o) => o.selected);
    twistDirection = selectedOption.value == 0 ? 1 : -1;
    _fillWithProperValues();
  }

  void _onColorModeChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option o) => o.selected);
    customColorsMode = selectedOption.value == 0;
    valueMax = customColorsMode ? speed.max : 360;
    customColorsProperty.visible = customColorsMode;
    _fillWithProperValues();
  }

  void _onCustomColorChange(List<Color> value) {
    _fillWithProperValues();
  }

  void _setColors(int x, int y, int z) {
    if (customColorsMode) {
      final Color first = leftDirection ? _lastColors[x][y][z] : _colors[x][y][z];
      final Color second = leftDirection ? _colors[x][y][z] : _lastColors[x][y][z];
      colors.setColor(x, y, z, Color.lerp(first, second, value / valueMax)!);
    } else {
      final Color color = _colors[x][y][z];
      final HSVColor hsv = HSVColor.fromColor(color);
      final double currentHue = hsv.hue + value;
      final HSVColor newHsv = HSVColor.fromAHSV(1, currentHue % 360, 1, 1);
      colors.setColor(x, y, z, newHsv.toColor());
    }
  }
}
