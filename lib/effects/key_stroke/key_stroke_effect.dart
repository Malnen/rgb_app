import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/cell_coords.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_state_type.dart';
import 'package:rgb_app/devices/key_dictionary.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_data.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_spread.dart';
import 'package:rgb_app/enums/key_code.dart';
import 'package:rgb_app/factories/property_factory.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/property.dart';

class KeyStrokeEffect extends Effect {
  final KeyBloc keyBloc;
  final List<Color> colors;

  @override
  List<Property<Object>> get properties => <Property<Object>>[
        duration,
        fadeSpeed,
      //  spreadDelay,
        opacitySpeed,
      ];

  late NumericProperty duration;
  late NumericProperty fadeSpeed;
  late NumericProperty spreadDelay;
  late NumericProperty opacitySpeed;
  late List<KeyStrokeSpread> _spreads;

  int colorIndex = 0;

  KeyStrokeEffect({required super.effectData, List<Color>? colors})
      : keyBloc = GetIt.instance.get(),
        duration = NumericProperty(
          min: 1,
          max: 100,
          name: 'Duration',
          value: 15,
        ),
        fadeSpeed = NumericProperty(
          value: 1,
          name: 'Fade Speed',
          min: 0.1,
          max: 10,
        ),
        spreadDelay = NumericProperty(
          value: 0,
          name: 'Spread Delay',
          min: 0,
          max: 0.25,
        ),
        opacitySpeed = NumericProperty(
          value: 0.15,
          name: 'Opacity Speed',
          min: 0.001,
          max: 1,
        ),
        colors = colors ?? <Color>[Colors.white, Colors.black] {
    _spreads = <KeyStrokeSpread>[];
    keyBloc.stream.listen(_onKeyEvent);
  }

  factory KeyStrokeEffect.fromJson(Map<String, dynamic> json) {
    final List<int> colors = json['colors'] as List<int>;
    final KeyStrokeEffect effect = KeyStrokeEffect(
      effectData: EffectDictionary.keyStrokeEffect.getWithNewKey(),
      colors: colors.map(Color.new).toList(),
    );
    effect.duration = PropertyFactory.getProperty(json['duration'] as Map<String, dynamic>) as NumericProperty;

    return effect;
  }

  @override
  void update() {
    for (KeyStrokeSpread spread in _spreads) {
      spread.spread();
    }
  }

  @override
  Map<String, dynamic> getData() {
    return <String, dynamic>{
      'duration': duration.toJson(),
      'colors': colors.map((Color color) => color.value).toList(),
    };
  }

  void _onKeyEvent(KeyState state) {
    if (state.type == KeyStateType.pressed) {
      _onKeyPressed(state);
    }
  }

  void _onKeyPressed(KeyState state) {
    final Color color = _getColor();
    final CellCoords coords = _getCoords(state);
    final KeyStrokeData data = KeyStrokeData(
      cellCoords: coords,
      color: color,
      duration: duration,
    );
    final KeyStrokeSpread spread = KeyStrokeSpread(
      data: data,
      duration: duration,
      fadeSpeed: fadeSpeed,
      opacitySpeed: opacitySpeed,
      spreadDelay: spreadDelay,
    );
    _spreads.add(spread);
  }

  CellCoords _getCoords(KeyState state) {
    final KeyCode keycode = KeyCodeExtension.fromKeyCode(state.keyCode);
    final Map<KeyCode, CellCoords> reverseKeys = KeyDictionary.reverseKeyCodes;
    final CellCoords? coords = reverseKeys[keycode];
    if (coords != null) {
      final KeyboardInterface? keyboardInterface = state.keyboardInterface;
      return coords.getWithOffset(
        offsetY: keyboardInterface?.offsetY ?? 0,
        offsetX: keyboardInterface?.offsetX ?? 0,
      );
    }

    return CellCoords.notFound();
  }

  Color _getColor() {
    final int index = colorIndex;
    colorIndex++;
    if (colorIndex >= colors.length) {
      colorIndex = 0;
    }

    return colors[index];
  }
}
