import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/wave/wave_effect_properties.dart';
import 'package:rgb_app/models/effect_grid_data.dart';
import 'package:rgb_app/models/option.dart';

class WaveEffect extends Effect with WaveEffectProperties {
  static const String className = 'WaveEffect';
  static const String name = 'Wave';

  List<Color> gradientColors = <Color>[];
  List<Color> shiftedColors = <Color>[];
  int colorsIncrementMax = 1;
  double value = 1;
  int direction = -1;
  bool leftDirection = false;
  bool customColorsMode = false;
  int customColorIndex = 0;

  WaveEffect(super.effectData) {
    initProperties();
  }

  @override
  void init() {
    waveDirection.addValueChangeListener(_onDirectionChange);
    colorModeProperty.addValueChangeListener(_onColorModeChange);
    customColorsProperty.addValueChangeListener(_onCustomColorChange);
    size.addValueChangeListener(_onSizeChange);
    super.init();
  }

  @override
  void update() {
    final EffectState state = effectBloc.state;
    final EffectGridData effectGridData = state.effectGridData;
    final List<List<Color>> colors = effectsColorsCubit.colors;
    final int sizeX = effectGridData.sizeX;
    final int sizeZ = effectGridData.sizeZ;
    if (colors.isNotEmpty) {
      _setColors(sizeX, sizeZ, colors);
    }

    _updateValue();
  }

  void _onDirectionChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option option) => option.selected);
    leftDirection = selectedOption.value == 0;
    direction = leftDirection ? 1 : -1;
  }

  void _onColorModeChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option option) => option.selected);
    customColorsMode = selectedOption.value == 0;
    colorsIncrementMax = customColorsMode ? 1000 : 360;
    if (customColorsMode) {
      _setCustomColors();
    }
  }

  void _onCustomColorChange(List<Color> colors) {
    _setCustomColors();
  }

  void _onSizeChange(double value) {
    _setCustomColors();
  }

  void _setColors(int sizeX, int sizeZ, List<List<Color>> colors) {
    final double shiftValue = value / colorsIncrementMax;
    for (int i = 0; i < sizeX; i++) {
      customColorsMode ? _setCustomColor(i, sizeZ, colors, shiftValue) : _setRainbowColor(i, sizeZ, colors);
    }
  }

  void _setCustomColor(int i, int sizeZ, List<List<Color>> colors, double shiftValue) {
    final int index = (i + customColorIndex * direction) % (shiftedColors.length - 1);
    final Color firstColor = leftDirection ? shiftedColors[index] : _getNextColor(index);
    final Color secondColor = leftDirection ? _getPreviousColor(index) : shiftedColors[index];
    final Color color = Color.lerp(secondColor, firstColor, shiftValue)!;
    for (int j = 0; j < sizeZ; j++) {
      try {
        colors[j][i] = color;
      } catch (_) {}
    }
  }

  Color _getNextColor(int i) {
    if (i < shiftedColors.length) {
      return shiftedColors[i + 1];
    }

    return shiftedColors.first;
  }

  Color _getPreviousColor(int i) {
    if (i > 0) {
      return shiftedColors[i - 1];
    }

    return shiftedColors.last;
  }

  void _setRainbowColor(int i, int sizeZ, List<List<Color>> colors) {
    final double hue = (i * size.value + value) % colorsIncrementMax;
    final HSVColor hsv = HSVColor.fromAHSV(1, hue, 1, 1);
    for (int j = 0; j < sizeZ; j++) {
      try {
        colors[j][i] = hsv.toColor();
      } catch (_) {}
    }
  }

  void _setCustomColors() {
    final List<Color> originalColors = customColorsProperty.value;
    if (originalColors.isEmpty) return;
    final List<Color> gradientColors = <Color>[];
    final List<Color> colors = List<Color>.from(originalColors);
    colors.add(colors.first);
    final int sizeX = effectBloc.sizeX;
    final int totalGradientColorCount = (sizeX * size.invertedValue / 4).floor();
    final int segmentCount = colors.length - 1;
    final int gradientColorCountPerSegment = (totalGradientColorCount / segmentCount).ceil();
    final int remainingGradientColorCount =
        totalGradientColorCount - ((gradientColorCountPerSegment - 1) * segmentCount);
    for (int i = 0; i < colors.length - 1; i++) {
      final List<Color> gradient = _getGradient(i, remainingGradientColorCount, gradientColorCountPerSegment, colors);
      gradientColors.addAll(gradient);
    }

    while (gradientColors.length < sizeX) {
      final List<Color> copy = List<Color>.from(gradientColors);
      gradientColors.addAll(copy);
    }

    this.gradientColors = gradientColors;
    shiftedColors = List<Color>.from(gradientColors);
  }

  List<Color> _getGradient(
    int i,
    int remainingGradientColorCount,
    int gradientColorCountPerSegment,
    List<Color> colors,
  ) {
    final int gradientColorCount =
        i < remainingGradientColorCount ? gradientColorCountPerSegment : gradientColorCountPerSegment - 1;
    final Color startColor = colors[i];
    final Color endColor = colors[i + 1];
    final List<Color> gradient = _createGradient(
      startColor,
      endColor,
      gradientColorCount,
    );
    return gradient;
  }

  List<Color> _createGradient(Color startColor, Color endColor, int count) {
    return List<Color>.generate(count, (int index) {
      final double ratio = index / (count - 1);
      return Color.lerp(startColor, endColor, ratio)!;
    });
  }

  void _updateValue() {
    final int multiplier = customColorsMode ? 100 : 1;
    value += speed.adjustedValue * direction * multiplier;
    if (value < 0 || value > colorsIncrementMax) {
      value = value % colorsIncrementMax;
      customColorIndex++;
      customColorIndex %= shiftedColors.length - 1;
    }
  }
}
