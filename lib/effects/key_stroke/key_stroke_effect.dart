import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_state_type.dart';
import 'package:rgb_app/devices/key_dictionary.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';
import 'package:rgb_app/effects/common/ripple.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/enums/key_code.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/factories/property_factory.dart';
import 'package:rgb_app/models/colors_property.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/property.dart';

class KeyStrokeEffect extends Effect {
  final KeyBloc keyBloc;

  @override
  List<Property<Object>> get properties => <Property<Object>>[
        duration,
        expansion,
        fadeSpeed,
        colorsProperty,
      ];

  late NumericProperty duration;
  late NumericProperty expansion;
  late NumericProperty fadeSpeed;
  late ColorsProperty colorsProperty;
  late List<Ripple> _ripples;

  int colorIndex = 0;

  KeyStrokeEffect(super.effectData)
      : keyBloc = GetIt.instance.get(),
        duration = NumericProperty(
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
        ) {
    _ripples = <Ripple>[];
    keyBloc.stream.listen(_onKeyEvent);
    colorsProperty = ColorsProperty(
      value: <Color>[
        Colors.white,
        Colors.black,
      ],
      name: 'Colors',
    );
  }

  factory KeyStrokeEffect.fromJson(Map<String, Object?> json) {
    final KeyStrokeEffect effect = KeyStrokeEffect(EffectDictionary.keyStrokeEffect);
    effect.duration = PropertyFactory.getProperty<NumericProperty>(json['duration'] as Map<String, Object?>);
    effect.expansion = PropertyFactory.getProperty<NumericProperty>(json['expansion'] as Map<String, Object?>);
    effect.fadeSpeed = PropertyFactory.getProperty<NumericProperty>(json['fadeSpeed'] as Map<String, Object?>);
    effect.colorsProperty = PropertyFactory.getProperty<ColorsProperty>(json['colors'] as Map<String, Object?>);

    return effect;
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

  void _processRipple(Ripple ripple, Point<int> position, List<List<Color>> colors) {
    final double opacity = ripple.getOpacity(position);
    final Color currentColor = colors[position.y][position.x];
    colors[position.y][position.x] = ColorExtension.mix(
      ripple.color,
      currentColor,
      opacity,
    );
  }

  @override
  Map<String, Object?> getData() {
    return <String, Object?>{
      'duration': duration.toJson(),
      'expansion': expansion.toJson(),
      'fadeSpeed': fadeSpeed.toJson(),
      'colors': colorsProperty.toJson(),
    };
  }

  void _onKeyEvent(KeyState state) {
    if (state.type == KeyStateType.pressed) {
      _onKeyPressed(state);
    }
  }

  void _onKeyPressed(KeyState state) {
    final Color color = _getColor();
    final Point<int> center = _getCenter(state);
    final Ripple ripple = Ripple(
      center: center,
      lifespan: duration.value,
      color: color,
    );
    _ripples.add(ripple);
  }

  Point<int> _getCenter(KeyState state) {
    final KeyCode keycode = KeyCodeExtension.fromKeyCode(state.keyCode);
    final Map<KeyCode, Point<int>> reverseKeys = KeyDictionary.reverseKeyCodes;
    final Point<int>? position = reverseKeys[keycode];
    if (position != null) {
      final KeyboardInterface? keyboardInterface = state.keyboardInterface;
      return Point<int>(
        position.x + (keyboardInterface?.offsetX ?? 0),
        position.y + (keyboardInterface?.offsetY ?? 0),
      );
    }

    return Point<int>(-1, -1);
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
