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

class WaveEffect extends Effect {
  late NumericProperty size;
  late NumericProperty speed;
  late Property<Set<Option>> waveDirection;
  late Property<Set<Option>> colorModeProperty;
  late ColorsProperty customColorsProperty;
  late List<Color> gradientColors;
  late List<Color> shiftedColors;
  late int colorsIncrementMax;
  double value = 1;
  int direction = -1;
  bool leftDirection = false;
  bool customColorsMode = false;
  int customColorIndex = 0;

  @override
  List<Property<Object>> get properties => <Property<Object>>[
        size,
        speed,
        waveDirection,
        colorModeProperty,
        if (customColorsMode) customColorsProperty,
      ];

  WaveEffect({
    required super.effectData,
  })  : size = NumericProperty(
          value: 15,
          name: 'Size',
          min: 1,
          max: 20,
        ),
        speed = NumericProperty(
          value: 2.5,
          name: 'Speed',
          min: 1,
          max: 20,
        ),
        waveDirection = OptionProperty(
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
          name: 'Wave Direction',
        ),
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
        ),
        customColorsProperty = ColorsProperty(
          value: <Color>[
            Colors.white,
            Colors.black,
          ],
          name: 'Custom Colors',
        );

  factory WaveEffect.fromJson(Map<String, dynamic> json) {
    final WaveEffect effect = WaveEffect(
      effectData: EffectDictionary.waveEffect.getWithNewKey(),
    );
    effect.size = PropertyFactory.getProperty(json['size'] as Map<String, dynamic>) as NumericProperty;
    effect.speed = PropertyFactory.getProperty(json['speed'] as Map<String, dynamic>) as NumericProperty;
    effect.waveDirection = PropertyFactory.getProperty(json['waveDirection'] as Map<String, dynamic>) as OptionProperty;
    effect.colorModeProperty = PropertyFactory.getProperty(json['colorMode'] as Map<String, dynamic>) as OptionProperty;
    effect.customColorsProperty =
        PropertyFactory.getProperty(json['customColors'] as Map<String, dynamic>) as ColorsProperty;

    return effect;
  }

  @override
  void init() {
    waveDirection.onChanged = _onDirectionChange;
    _onDirectionChange(waveDirection.value);
    colorModeProperty.onChanged = _onColorModeChange;
    _onColorModeChange(colorModeProperty.value);
    customColorsProperty.onChanged = _onCustomColorChange;
    _onCustomColorChange(customColorsProperty.value);
    size.onChanged = _onSizeChange;
    _onSizeChange(size.value);
  }

  @override
  Map<String, dynamic> getData() {
    return <String, dynamic>{
      'size': size.toJson(),
      'speed': speed.toJson(),
      'waveDirection': waveDirection.toJson(),
      'colorMode': colorModeProperty.toJson(),
      'customColors': customColorsProperty.toJson(),
    };
  }

  @override
  void update() {
    final EffectState state = effectBloc.state;
    final EffectGridData effectGridData = state.effectGridData;
    final List<List<Color>> colors = effectBloc.colors;
    final int sizeX = effectGridData.sizeX;
    final int sizeY = effectGridData.sizeY;
    if (colors.isNotEmpty) {
      _setColors(sizeX, sizeY, colors);
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

  void _setColors(int sizeX, int sizeY, List<List<Color>> colors) {
    final double shiftValue = value / colorsIncrementMax;
    for (int i = 0; i < sizeX; i++) {
      customColorsMode ? _setCustomColor(i, sizeY, colors, shiftValue) : _setRainbowColor(i, sizeY, colors);
    }
  }

  void _setCustomColor(int i, int sizeY, List<List<Color>> colors, double shiftValue) {
    final int index = (i + customColorIndex * direction) % (shiftedColors.length - 1);
    final Color firstColor = leftDirection ? shiftedColors[index] : _getNextColor(index);
    final Color secondColor = leftDirection ? _getPreviousColor(index) : shiftedColors[index];
    final Color color = Color.lerp(secondColor, firstColor, shiftValue)!;
    for (int j = 0; j < sizeY; j++) {
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

  void _setRainbowColor(int i, int sizeY, List<List<Color>> colors) {
    final double hue = (i * size.value + value) % colorsIncrementMax;
    final HSVColor hsv = HSVColor.fromAHSV(1, hue, 1, 1);
    for (int j = 0; j < sizeY; j++) {
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
    value += speed.value * direction * multiplier;
    if (value < 0 || value > colorsIncrementMax) {
      value = value % colorsIncrementMax;
      customColorIndex++;
      customColorIndex %= shiftedColors.length - 1;
    }
  }
}
