import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/devices/key_dictionary.dart';
import 'package:rgb_app/devices/keyboard_key.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_data.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

class KeyStrokeSpread {
  final KeyStrokeData data;
  final EffectBloc effectBloc;
  final double fadeSpeed = 1;
  final double spreadDelay = 5;
  final double opacitySpeed = 0.25;
  final double duration;
  late HashSet<KeyboardKey?> _visitedKeys;
  List<KeyStrokeData> _spread = [];

  List<List<Color>> get colors => effectBloc.colors;

  KeyStrokeSpread({
    required this.data,
    required this.effectBloc,
    required this.duration,
  }) {
    _spread.add(data);
    _visitedKeys = HashSet();
  }

  void spread() {
    List<KeyStrokeData> newSpread = [];
    for (KeyStrokeData data in _spread) {
      final Color currentColor = colors[data.y][data.x];
      final Color newColor = data.color;
      colors[data.y][data.x] = newColor; /*ColorExtension.mix(
        currentColor,
        data.color,
        data.opacity,
      );*/
      final double duration = data.duration;
      final double opacity = data.opacity;
      final bool increment = data.increment;
      final KeyStrokeData newData = data.copyWith(
        duration: duration - fadeSpeed,
        opacity: _getOpacity(increment, opacity),
      );
      if (duration >= 0) {
        newSpread.add(newData);
        _tryToPropagate(newData, newSpread);
/*        if (opacity >= 1) {
          _tryToPropagate(newData, newSpread);
        }*/
      }
    }

    _spread = newSpread;
  }

  double _getOpacity(bool increment, double opacity) {
    final double targetOpacitySpeed =
    increment ? opacitySpeed : opacitySpeed * -1;
    final double targetOpacity = opacity + targetOpacitySpeed;
    if (targetOpacity > 1) {
      return 1;
    } else if (targetOpacity < 0) {
      return 0;
    }

    return targetOpacity;
  }

  void _tryToPropagate(KeyStrokeData newData, List<KeyStrokeData> newSpread) {
    KeyboardKey? keyboardKey = newData.keyboardKey;
    final bool newKey = !_visitedKeys.contains(keyboardKey);
    if (newKey) {
      _propagateSpread(newData, newSpread);
    }
  }

  void _propagateSpread(KeyStrokeData data, List<KeyStrokeData> newSpread) {
    final EffectState effectState = effectBloc.state;
    final EffectGridData effectGridData = effectState.effectGridData;
    final int sizeX = effectGridData.sizeX;
    final int sizeY = effectGridData.sizeY;

    _propagateToRight(data, sizeX, newSpread);
    _propagateToLeft(data, newSpread);
    _propagateToTop(data, sizeY, newSpread);
    _propagateToDown(data, newSpread);
  }

  void _propagateToRight(KeyStrokeData data, int sizeX,
      List<KeyStrokeData> newSpread) {
    int newX = data.x + 1;
    int newY = data.y;
    if (newX < sizeX) {
      _propagateToNext(
        newX: newX,
        newY: newY,
        data: data,
        newSpread: newSpread,
        offsetX: 1,
      );
    }
  }

  void _propagateToLeft(KeyStrokeData data, List<KeyStrokeData> newSpread) {
    int newX = data.x - 1;
    int newY = data.y;
    if (newX >= 0) {
      _propagateToNext(
        newX: newX,
        newY: newY,
        data: data,
        newSpread: newSpread,
        offsetX: -1,
      );
    }
  }

  void _propagateToTop(KeyStrokeData data, int sizeY,
      List<KeyStrokeData> newSpread) {
    int newX = data.x;
    int newY = data.y + 1;
    if (newY < sizeY) {
      _propagateToNext(
        newX: newX,
        newY: newY,
        data: data,
        newSpread: newSpread,
        offsetY: 1,
      );
    }
  }

  void _propagateToDown(KeyStrokeData data, List<KeyStrokeData> newSpread) {
    int newX = data.x;
    int newY = data.y - 1;
    if (newY >= 0) {
      _propagateToNext(
        newX: newX,
        newY: newY,
        data: data,
        newSpread: newSpread,
        offsetY: -1,
      );
    }
  }

  void _propagateToNext({
    required int newX,
    required int newY,
    required KeyStrokeData data,
    required List<KeyStrokeData> newSpread,
    int offsetX = 0,
    int offsetY = 0,
  }) {
    final KeyboardKey? dataKeyboardKey = data.keyboardKey;
    final KeyboardKey? keyboardKey = KeyDictionary.getWithOffset(
      keyboardKey: dataKeyboardKey,
      offsetY: offsetY,
      offsetX: offsetX,
    );
    if (keyboardKey != null) {
      final KeyStrokeData spreadData = KeyStrokeData(
        x: newX,
        y: newY,
        color: data.color,
        duration: duration,
        keyboardKey: keyboardKey,
      );
      newSpread.add(spreadData);
      _visitedKeys.add(dataKeyboardKey);
    }
  }
}
