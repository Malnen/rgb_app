import 'package:flutter/material.dart';
import 'package:keyboard_event/keyboard_event.dart';
import 'package:rgb_app/blocs/effects_bloc/cell_coords.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_state_type.dart';
import 'package:rgb_app/devices/key_dictionary.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_data.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_spread.dart';
import 'package:rgb_app/enums/key_code.dart';

class KeyStrokeEffect extends Effect {
  final KeyBloc keyBloc;
  final double duration = 15;
  final List<Color> colors = [
    Colors.white,
    Colors.black,
  ];
  late List<KeyStrokeSpread> _spreads;
  int colorIndex = 0;

  KeyStrokeEffect({
    required super.effectBloc,
    required this.keyBloc,
  }) {
    _spreads = [];
    keyBloc.stream.listen(_onKeyEvent);
  }
  @override
  void update() {
    for (KeyStrokeSpread spread in _spreads) {
      spread.spread();
    }
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
      effectBloc: effectBloc,
      duration: duration,
    );
    _spreads.add(spread);
  }

  CellCoords _getCoords(KeyState state) {
    final KeyCode keycode = KeyCodeExtension.fromKeyCode(state.keyCode);
    final Map<KeyCode, CellCoords> reverseKeys = KeyDictionary.reverseKeyCodes;
    final CellCoords? coords = reverseKeys[keycode];
    if (coords != null) {
      return coords.getWithOffset(
        offsetY: state.offsetY,
        offsetX: state.offsetX,
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
