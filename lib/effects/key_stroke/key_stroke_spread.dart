import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/cell_coords.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_data.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/models/numeric_property.dart';

class KeyStrokeSpread {
  final KeyStrokeData data;
  final NumericProperty fadeSpeed;
  final NumericProperty spreadDelay;
  final NumericProperty opacitySpeed;
  final NumericProperty duration;
  late HashSet<CellCoords> _visitedCells;
  late double _startDecreasing;
  late EffectBloc _effectBloc;
  List<KeyStrokeData> _spread = <KeyStrokeData>[];

  List<List<Color>> get colors => _effectBloc.colors;

  int get sizeX => _effectBloc.sizeX;

  int get sizeY => _effectBloc.sizeY;

  KeyStrokeSpread({
    required this.data,
    required this.duration,
    required this.fadeSpeed,
    required this.spreadDelay,
    required this.opacitySpeed,
  }) {
    _effectBloc = GetIt.instance.get();
    _spread.add(data);
    _visitedCells = HashSet<CellCoords>();
    _startDecreasing = fadeSpeed.value / opacitySpeed.value;
  }

  void spread() {
    final List<KeyStrokeData> newSpread = <KeyStrokeData>[];
    for (KeyStrokeData data in _spread) {
      _spreadData(data, newSpread);
    }

    _spread = newSpread;
  }

  bool canBeDeleted() {
    return _spread.isEmpty;
  }

  void _spreadData(
    final KeyStrokeData data,
    final List<KeyStrokeData> newSpread,
  ) {
    _setNewColor(data);
    final NumericProperty duration = data.duration;
    final double opacity = data.opacity;
    final KeyStrokeData newData = _getNewData(data, duration, opacity);
    final bool hasDuration = duration.value >= 0;
    if (hasDuration) {
      newSpread.add(newData);
      _propagateAfterDelay(duration, newData, newSpread);
    }
  }

  void _setNewColor(KeyStrokeData data) {
    final CellCoords cellCoords = data.cellCoords;
    try {
      final Color currentColor = colors[cellCoords.y][cellCoords.x];
      colors[cellCoords.y][cellCoords.x] = ColorExtension.mix(
        data.color,
        currentColor,
        data.opacity,
      );
    } catch (_) {}
  }

  KeyStrokeData _getNewData(
    final KeyStrokeData data,
    final NumericProperty duration,
    final double opacity,
  ) {
    final bool increment = data.increment;
    return data.copyWith(
      duration: duration.copyWith(value: duration.value - fadeSpeed.value),
      increment: _getIncrement(duration),
      opacity: _getOpacity(increment, opacity),
    );
  }

  bool _getIncrement(NumericProperty duration) {
    return duration.value > _startDecreasing;
  }

  double _getOpacity(bool increment, double opacity) {
    final double targetOpacitySpeed = increment ? opacitySpeed.value : opacitySpeed.value * -1;
    final double targetOpacity = opacity + targetOpacitySpeed;
    if (targetOpacity > 1) {
      return 1;
    } else if (targetOpacity < 0) {
      return 0;
    }

    return targetOpacity;
  }

  void _propagateAfterDelay(
    final NumericProperty duration,
    final KeyStrokeData newData,
    final List<KeyStrokeData> newSpread,
  ) {
    final bool canPropagate = this.duration.value - duration.value >= spreadDelay.value;
    if (canPropagate) {
      _tryToPropagate(newData, newSpread);
    }
  }

  void _tryToPropagate(KeyStrokeData newData, List<KeyStrokeData> newSpread) {
    final CellCoords cellCoords = newData.cellCoords;
    final bool newKey = !_visitedCells.contains(cellCoords);
    if (newKey) {
      _propagateSpread(newData, newSpread);
    }
  }

  void _propagateSpread(KeyStrokeData data, List<KeyStrokeData> newSpread) {
    _propagateToRight(data, newSpread);
    _propagateToLeft(data, newSpread);
    _propagateToTop(data, newSpread);
    _propagateToDown(data, newSpread);
  }

  void _propagateToRight(KeyStrokeData data, List<KeyStrokeData> newSpread) {
    final CellCoords coords = data.cellCoords;
    final CellCoords newCoords = coords.getWithOffset(offsetX: 1);
    _propagateToNext(
      coords: coords,
      newCoords: newCoords,
      data: data,
      newSpread: newSpread,
    );
  }

  void _propagateToLeft(KeyStrokeData data, List<KeyStrokeData> newSpread) {
    final CellCoords coords = data.cellCoords;
    final CellCoords newCoords = coords.getWithOffset(offsetX: -1);
    _propagateToNext(
      coords: coords,
      newCoords: newCoords,
      data: data,
      newSpread: newSpread,
    );
  }

  void _propagateToTop(KeyStrokeData data, List<KeyStrokeData> newSpread) {
    final CellCoords coords = data.cellCoords;
    final CellCoords newCoords = coords.getWithOffset(offsetY: 1);
    _propagateToNext(
      coords: coords,
      newCoords: newCoords,
      data: data,
      newSpread: newSpread,
    );
  }

  void _propagateToDown(KeyStrokeData data, List<KeyStrokeData> newSpread) {
    final CellCoords coords = data.cellCoords;
    final CellCoords newCoords = coords.getWithOffset(offsetY: -1);
    _propagateToNext(
      coords: coords,
      newCoords: newCoords,
      data: data,
      newSpread: newSpread,
    );
  }

  void _propagateToNext({
    required CellCoords newCoords,
    required CellCoords coords,
    required KeyStrokeData data,
    required List<KeyStrokeData> newSpread,
  }) {
    final bool canPropagate = _canPropagate(newCoords);
    if (canPropagate) {
      final KeyStrokeData spreadData = KeyStrokeData(
        color: data.color,
        duration: duration,
        cellCoords: newCoords,
      );
      newSpread.add(spreadData);
      _visitedCells.add(coords);
    }
  }

  bool _canPropagate(CellCoords newCoords) {
    final int x = newCoords.x;
    final int y = newCoords.y;

    return x >= 0 && x < sizeX && y >= 0 && y < sizeY;
  }
}
