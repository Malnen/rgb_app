import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/spiral/sprial_effect_properties.dart';
import 'package:rgb_app/models/color_list.dart';
import 'package:rgb_app/models/option.dart';

class SpiralEffect extends Effect with SpiralEffectProperties {
  static const String className = 'SpiralEffect';
  static const String name = 'SpiralEffect';

  late ColorList _colors;
  late ColorList _lastColors;
  late double valueMax;

  double value = 1;
  double spinDirection = 1;
  double twistDirection = 1;
  double rotation = 0;
  bool leftDirection = false;
  bool customColorsMode = false;

  List<Color> get customColors => customColorsProperty.value;
  int get customColorsLength => customColors.length;

  SpiralEffect(super.effectData) {
    initProperties();
  }

  @override
  void init() {
    _fillColors();
    effectBloc.stream.listen(_effectGridListener);
    twist.addListener(_fillWithProperValues);
    center.addListener(_fillWithProperValues);
    axisInfluence.addListener(_fillWithProperValues);
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
    _colors = ColorList(
      width: effectBloc.sizeX,
      height: effectBloc.sizeY,
      depth: effectBloc.sizeZ,
    );
    _lastColors = _colors.copy();
    _fillWithProperValues();
  }

  void _fillWithProperValues() {
    _lastColors = _colors.copy();
    final int width = colors.width;
    final int height = colors.height;
    final int depth = colors.depth;
    final double centerX = center.value.x * width;
    final double centerY = center.value.y * height;
    final double centerZ = center.value.z * depth;
    final double influenceX = axisInfluence.value.x;
    final double influenceY = axisInfluence.value.y;
    final double influenceZ = axisInfluence.value.z;

    processUsedIndexes((int x, int y, int z) {
      final double dx = (x - centerX) * influenceX;
      final double dy = (y - centerY) * influenceY;
      final double dz = (z - centerZ) * influenceZ;
      final double distance = sqrt(dx * dx + dy * dy + dz * dz);
      final double safeDistance = distance == 0 ? 1e-6 : distance;
      final double twistFactor = safeDistance * twist.value;

      double angle;
      if (influenceY == 0 && influenceX != 0 && influenceZ != 0) {
        angle = atan2(dz, dx);
      } else if (influenceX == 0 && influenceY != 0 && influenceZ != 0) {
        angle = atan2(dz, dy);
      } else if (influenceZ == 0 && influenceX != 0 && influenceY != 0) {
        angle = atan2(dy, dx);
      } else {
        angle = atan2(sqrt(dy * dy + dz * dz), dx);
      }

      angle += twistFactor * twistDirection + rotation;

      final double hue = _getHue(angle);

      if (customColorsMode) {
        _calculateCustomColor(hue, x, y, z);
      } else {
        _colors.setColor(x, y, z, HSVColor.fromAHSV(1, hue, 1, 1).toColor());
      }
    });
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
    final Color interpolated = Color.lerp(
      customColors[firstColor],
      customColors[secondColor],
      fraction,
    )!;
    _colors.setColor(x, y, z, interpolated);
  }

  void _onSpinDirectionChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((o) => o.selected);
    spinDirection = selectedOption.value == 0 ? 1 : -1;
    leftDirection = selectedOption.value == 0;
  }

  void _onTwistDirectionChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((o) => o.selected);
    twistDirection = selectedOption.value == 0 ? 1 : -1;
    _fillWithProperValues();
  }

  void _onColorModeChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((o) => o.selected);
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
      final Color first = leftDirection ? _lastColors.getColor(x, y, z) : _colors.getColor(x, y, z);
      final Color second = leftDirection ? _colors.getColor(x, y, z) : _lastColors.getColor(x, y, z);
      colors.setColor(x, y, z, Color.lerp(first, second, value / valueMax)!);
    } else {
      final Color color = _colors.getColor(x, y, z);
      final HSVColor hsv = HSVColor.fromColor(color);
      final double currentHue = hsv.hue + value;
      final HSVColor newHsv = HSVColor.fromAHSV(1, currentHue % 360, 1, 1);
      colors.setColor(x, y, z, newHsv.toColor());
    }
  }
}