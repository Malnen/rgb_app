import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rgb_app/effects/common/ripple.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_effect_properties.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rxdart/rxdart.dart';

class RippleEffect extends Effect with KeyStrokeEffectProperties {
  static const String className = 'RippleEffect';
  static const String name = 'Ripple';

  @override
  List<Property<Object>> get properties => <Property<Object>>[
        duration,
        expansion,
        fadeSpeed,
        ripplePeriod,
        colorsProperty,
      ];

  final StreamController<double> _periodStream;

  late NumericProperty ripplePeriod;
  late List<Ripple> _ripples;

  Timer? _timer;

  int colorIndex = 0;

  RippleEffect(super.effectData) : _periodStream = StreamController<double>() {
    initProperties();
    _ripples = <Ripple>[];
    ripplePeriod = NumericProperty(
      min: 0.1,
      max: 10,
      name: 'Ripple Period',
      idn: 'ripplePeriod',
      initialValue: 1,
    );
    _periodStream.stream.debounceTime(Duration(milliseconds: 250)).listen(_onRipplePeriodChange);
  }

  @override
  void init() {
    ripplePeriod.addValueChangeListener(_periodStream.add);
    super.init();
  }

  @override
  void update() {
    final List<List<Color>> colors = effectsColorsCubit.colors;
    for (Ripple ripple in _ripples) {
      for (int x = 0; x < effectBloc.sizeX; x++) {
        for (int y = 0; y < effectBloc.sizeZ; y++) {
          _processRipple(ripple, Point<int>(x, y), colors);
        }
      }

      ripple.update(expansionSpeed: expansion.value, deathSpeed: fadeSpeed.value);
    }

    _ripples.removeWhere((Ripple ripple) => ripple.canBeDeleted);
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
    colors[position.y][position.x] = ripple.color.mix(
      currentColor,
      opacity,
    );
  }

  Point<int> _getCenter() {
    final Random random = Random();
    final int x = random.nextInt(effectBloc.sizeX);
    final int y = random.nextInt(effectBloc.sizeZ);

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
