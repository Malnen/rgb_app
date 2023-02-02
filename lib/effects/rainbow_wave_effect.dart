import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/factories/property_factory.dart';
import 'package:rgb_app/models/effect_grid_data.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/models/property.dart';

class RainbowWaveEffect extends Effect {
  late Property<double> size;
  late Property<double> speed;
  late Property<Set<Option>> waveDirection;
  double value = 1;
  double direction = -1;

  @override
  List<Property<Object>> get properties => <Property<Object>>[
        size,
        speed,
        waveDirection,
      ];

  RainbowWaveEffect({
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
        );

  factory RainbowWaveEffect.fromJson(Map<String, dynamic> json) {
    final RainbowWaveEffect effect = RainbowWaveEffect(
      effectData: EffectDictionary.rainbowWaveEffect.getWithNewKey(),
    );
    effect.size = PropertyFactory.getProperty(json['size'] as Map<String, dynamic>) as NumericProperty;
    effect.speed = PropertyFactory.getProperty(json['speed'] as Map<String, dynamic>) as NumericProperty;
    effect.waveDirection = PropertyFactory.getProperty(json['waveDirection'] as Map<String, dynamic>) as OptionProperty;

    return effect;
  }

  @override
  void init() {
    waveDirection.onChanged = _onDirectionChange;
    _onDirectionChange(waveDirection.value);
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

    value += speed.value * direction;
    value = value % 360;
  }

  @override
  Map<String, dynamic> getData() {
    return <String, dynamic>{
      'size': size.toJson(),
      'speed': speed.toJson(),
      'waveDirection': waveDirection.toJson(),
    };
  }

  void _onDirectionChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option option) => option.selected);
    direction = selectedOption.value == 0 ? 1 : -1;
  }

  void _setColors(int sizeX, int sizeY, List<List<Color>> colors) {
    for (int i = 0; i < sizeX; i++) {
      _setColor(i, sizeY, colors);
    }
  }

  void _setColor(int i, int sizeY, List<List<Color>> colors) {
    final double hue = (i * size.value + value) % 360;
    final HSVColor hsv = HSVColor.fromAHSV(1, hue, 1, 1);
    for (int j = 0; j < sizeY; j++) {
      try {
        colors[j][i] = hsv.toColor();
      } catch (_) {}
    }
  }
}
