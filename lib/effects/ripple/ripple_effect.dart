import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rgb_app/effects/common/ripple.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/factories/property_factory.dart';
import 'package:rgb_app/models/colors_property.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rxdart/rxdart.dart';

class RippleEffect extends Effect {
  @override
  List<Property<Object>> get properties => <Property<Object>>[
        duration,
        expansion,
        fadeSpeed,
        ripplePeriod,
        colorsProperty,
      ];

  final StreamController<double> _periodStream;

  late NumericProperty duration;
  late NumericProperty expansion;
  late NumericProperty fadeSpeed;
  late NumericProperty ripplePeriod;
  late ColorsProperty colorsProperty;
  late List<Ripple> _ripples;

  Timer? _timer;

  int colorIndex = 0;

  RippleEffect(super.effectData)
      : duration = NumericProperty(
          min: 1,
          max: 10,
          name: 'Duration',
          value: 4,
        ),
        expansion = NumericProperty(
          min: 0.01,
          max: 1.5,
          name: 'Expansion',
          value: 0.25,
        ),
        fadeSpeed = NumericProperty(
          min: 0.01,
          max: 0.5,
          name: 'Fade Speed',
          value: 0.1,
        ),
        _periodStream = StreamController<double>() {
    _ripples = <Ripple>[];
    ripplePeriod = NumericProperty(
      min: 0.1,
      max: 10,
      name: 'Ripple Period',
      value: 1,
      onChanged: _periodStream.add,
    );
    colorsProperty = ColorsProperty(
      value: <Color>[
        Colors.white,
        Colors.black,
      ],
      name: 'Colors',
    );
    _periodStream.stream.debounceTime(Duration(milliseconds: 250)).listen(_onRipplePeriodChange);
  }

  factory RippleEffect.fromJson(Map<String, Object?> json) {
    final RippleEffect effect = RippleEffect(EffectDictionary.rippleEffect);
    effect.duration = PropertyFactory.getProperty<NumericProperty>(json['duration'] as Map<String, Object?>);
    effect.expansion = PropertyFactory.getProperty<NumericProperty>(json['expansion'] as Map<String, Object?>);
    effect.fadeSpeed = PropertyFactory.getProperty<NumericProperty>(json['fadeSpeed'] as Map<String, Object?>);
    effect.ripplePeriod = PropertyFactory.getProperty<NumericProperty>(json['ripplePeriod'] as Map<String, Object?>);
    effect.colorsProperty = PropertyFactory.getProperty<ColorsProperty>(json['colors'] as Map<String, Object?>);

    return effect;
  }

  @override
  void init() {
    ripplePeriod.onChanged = _periodStream.add;
    ripplePeriod.onChange(ripplePeriod.value);
  }

  @override
  void update() {
    final List<List<Color>> colors = effectsColorsCubit.colors;
    for (Ripple ripple in _ripples) {
      for (int x = 0; x < effectBloc.sizeX; x++) {
        for (int y = 0; y < effectBloc.sizeY; y++) {
          _processRipple(ripple, Point<int>(x, y), colors);
        }
      }

      ripple.update(expansionSpeed: expansion.value, deathSpeed: fadeSpeed.value);
    }

    _ripples.removeWhere((Ripple ripple) => ripple.canBeDeleted);
  }

  @override
  Map<String, Object?> getData() {
    return <String, Object?>{
      'duration': duration.toJson(),
      'expansion': expansion.toJson(),
      'fadeSpeed': fadeSpeed.toJson(),
      'ripplePeriod': ripplePeriod.toJson(),
      'colors': colorsProperty.toJson(),
    };
  }

  void _onRipplePeriodChange(double time) {
    final int milliseconds = (time * 1000).toInt();
    _timer?.cancel();
    print(time);
    Timer.periodic(Duration(milliseconds: milliseconds), (Timer timer) {
      _timer = timer;
      final Color color = _getColor();
      final Point<int> center = _getCenter();
      final Ripple ripple = Ripple(
        center: center,
        lifespan: duration.value,
        color: color,
      );
      _ripples.add(ripple);
    });
  }

  void _processRipple(Ripple ripple, Point<int> position, List<List<Color>> colors) {
    final double opacity = ripple.getOpacity(position);
    final Color currentColor = colors[position.y][position.x];
    colors[position.y][position.x] = ColorExtension.mix(
      ripple.color,
      currentColor,
      opacity,
    );
  }

  Point<int> _getCenter() {
    final Random random = Random();
    final int x = random.nextInt(effectBloc.sizeX);
    final int y = random.nextInt(effectBloc.sizeY);

    return Point<int>(x, y);
  }

  Color _getColor() {
    final List<Color> colors = colorsProperty.value;
    final int index = colorIndex;
    colorIndex++;
    if (colorIndex >= colors.length) {
      colorIndex = 0;
    }

    return colors[index];
  }
}
