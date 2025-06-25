import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rgb_app/classes/fixed_size_list.dart';
import 'package:rgb_app/effects/common/ripple.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_effect_properties.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vector_math/vector_math.dart';

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
  late FixedSizeList<Ripple> _ripples;

  Timer? _timer;

  int colorIndex = 0;

  RippleEffect(super.effectData) : _periodStream = StreamController<double>() {
    initProperties();
    _ripples = FixedSizeList<Ripple>(maxSize: 25);
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
    for (Ripple ripple in _ripples) {
      processUsedIndexes(
        (int x, int y, int z) => _processRipple(ripple, Vector3(x.toDouble(), y.toDouble(), z.toDouble())),
      );
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
      final Vector3 center = _getCenter();
      final Ripple ripple = Ripple(
        center: center,
        lifespan: duration.value,
        color: color,
      );
      _ripples.add(ripple);
    });
  }

  void _processRipple(Ripple ripple, Vector3 position) {
    final double opacity = ripple.getOpacity(position);
    final Color currentColor = colors.getColor(position.x.toInt(), position.y.toInt(), position.z.toInt());
    colors.setColor(
      position.x.toInt(),
      position.y.toInt(),
      position.z.toInt(),
      ripple.color.mix(
        currentColor,
        opacity,
      ),
    );
  }

  Vector3 _getCenter() {
    final Random random = Random();
    final int x = random.nextInt(effectBloc.sizeX);
    final int y = random.nextInt(effectBloc.sizeY);
    final int z = random.nextInt(effectBloc.sizeZ);

    return Vector3(x.toDouble(), y.toDouble(), z.toDouble());
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
