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
import 'package:rgb_app/effects/key_stroke/key_stroke_effect_properties.dart';
import 'package:rgb_app/enums/key_code.dart';
import 'package:rgb_app/extensions/color_extension.dart';

class KeyStrokeEffect extends Effect with KeyStrokeEffectProperties {
  static const String className = 'KeyStrokeEffect';
  static const String name = 'Key Stroke';

  final KeyBloc keyBloc;

  late final List<Ripple> _ripples;

  int colorIndex = 0;

  KeyStrokeEffect(super.effectData)
      : keyBloc = GetIt.instance.get(),
        _ripples = <Ripple>[] {
    initProperties();
    keyBloc.stream.listen(_onKeyEvent);
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

  void _processRipple(Ripple ripple, Point<int> position, List<List<Color>> colors) {
    final double opacity = ripple.getOpacity(position);
    final Color currentColor = colors[position.y][position.x];
    colors[position.y][position.x] = ripple.color.mix(
      currentColor,
      opacity,
    );
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
    final KeyboardInterface? keyboardInterface = state.keyboardInterface;
    if (keyboardInterface != null) {
      final KeyCode keycode = KeyCodeExtension.fromKeyCode(state.keyCode);
      final Map<KeyCode, Point<int>> reverseKeys =
          KeyDictionary.reverseKeyCodes(keyboardInterface.deviceData.deviceProductVendor.productVendor);
      final Point<int>? position = reverseKeys[keycode];
      if (position != null) {
        return Point<int>(
          position.x + keyboardInterface.offsetX,
          position.y + keyboardInterface.offsetZ,
        );
      }
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
