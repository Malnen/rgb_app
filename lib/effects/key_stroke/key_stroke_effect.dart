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
import 'package:vector_math/vector_math.dart';

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
    for (Ripple ripple in _ripples) {
      processUsedIndexes(
          (int x, int y, int z) => _processRipple(ripple, Vector3(x.toDouble(), y.toDouble(), z.toDouble())));
      ripple.update(expansionSpeed: expansion.value, deathSpeed: fadeSpeed.value);
    }

    _ripples.removeWhere((Ripple ripple) => ripple.canBeDeleted);
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

  void _onKeyEvent(KeyState state) {
    if (state.type == KeyStateType.pressed) {
      _onKeyPressed(state);
    }
  }

  void _onKeyPressed(KeyState state) {
    final Color color = _getColor();
    final Vector3 center = _getCenter(state);
    final Ripple ripple = Ripple(
      center: center,
      lifespan: duration.value,
      color: color,
    );
    _ripples.add(ripple);
  }

  Vector3 _getCenter(KeyState state) {
    final KeyboardInterface? keyboardInterface = state.keyboardInterface;
    if (keyboardInterface != null) {
      final KeyCode keycode = KeyCodeExtension.fromKeyCode(state.keyCode);
      final Map<KeyCode, Vector3> reverseKeys =
          KeyDictionary.reverseKeyCodes(keyboardInterface.deviceData.deviceProductVendor.productVendor);
      final Vector3? position = reverseKeys[keycode];
      if (position != null) {
        return Vector3(
          position.x + keyboardInterface.offsetX,
          position.y + keyboardInterface.offsetY,
          position.z + keyboardInterface.offsetZ,
        );
      }
    }

    return Vector3(-1, -1, -1);
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
