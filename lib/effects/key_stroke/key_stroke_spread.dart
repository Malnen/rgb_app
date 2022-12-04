import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/cell_coords.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_data.dart';
import 'package:rgb_app/extensions/color_extension.dart';

class KeyStrokeSpread {
  final KeyStrokeData data;
  final double fadeSpeed = 1;
  final double spreadDelay = 0;
  final double opacitySpeed = 0.15;
  final double duration;
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
  }) {
    _effectBloc = GetIt.instance.get();
    _spread.add(data);
    _visitedCells = HashSet<CellCoords>();
    _startDecreasing = fadeSpeed / opacitySpeed;
  }

  void spread() {
    final List<KeyStrokeData> newSpread = <KeyStrokeData>[];
    for (final KeyStrokeData data in _spread) {
      _spreadData(data, newSpread);
    }

    _spread = newSpread;
  }

  void _spreadData(final KeyStrokeData data, final List<KeyStrokeData> newSpread) {
    _setNewColor(data);
    final double duration = data.duration;
    final double opacity = data.opacity;
    final KeyStrokeData newData = _getNewData(data, duration, opacity);
    final bool hasDuration = duration >= 0;
    if (hasDuration) {
      newSpread.add(newData);
      _propagateAfterDelay(duration, newData, newSpread);
    }
  }

  void _setNewColor(final KeyStrokeData data) {
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
    final double duration,
    final double opacity,
  ) {
    final bool increment = data.increment;
    return data.copyWith(
      duration: duration - fadeSpeed,
      increment: _getIncrement(duration),
      opacity: _getOpacity(increment, opacity),
    );
  }

  bool _getIncrement(final double duration) {
    return duration > _startDecreasing;
  }

  double _getOpacity(final bool increment, final double opacity) {
    final double targetOpacitySpeed = increment ? opacitySpeed : opacitySpeed * -1;
    final double targetOpacity = opacity + targetOpacitySpeed;
    if (targetOpacity > 1) {
      return 1;
    } else if (targetOpacity < 0) {
      return 0;
    }

    return targetOpacity;
  }

  void _propagateAfterDelay(final double duration, final KeyStrokeData newData, final List<KeyStrokeData> newSpread) {
    final bool canPropagate = this.duration - duration >= spreadDelay;
    if (canPropagate) {
      _tryToPropagate(newData, newSpread);
    }
  }

  void _tryToPropagate(final KeyStrokeData newData, final List<KeyStrokeData> newSpread) {
    final CellCoords cellCoords = newData.cellCoords;
    final bool newKey = !_visitedCells.contains(cellCoords);
    if (newKey) {
      _propagateSpread(newData, newSpread);
    }
  }

  void _propagateSpread(final KeyStrokeData data, final List<KeyStrokeData> newSpread) {
    _propagateToRight(data, newSpread);
    _propagateToLeft(data, newSpread);
    _propagateToTop(data, newSpread);
    _propagateToDown(data, newSpread);
  }

  void _propagateToRight(final KeyStrokeData data, final List<KeyStrokeData> newSpread) {
    final CellCoords coords = data.cellCoords;
    final CellCoords newCoords = coords.getWithOffset(offsetX: 1);
    _propagateToNext(
      coords: coords,
      newCoords: newCoords,
      data: data,
      newSpread: newSpread,
    );
  }

  void _propagateToLeft(final KeyStrokeData data, final List<KeyStrokeData> newSpread) {
    final CellCoords coords = data.cellCoords;
    final CellCoords newCoords = coords.getWithOffset(offsetX: -1);
    _propagateToNext(
      coords: coords,
      newCoords: newCoords,
      data: data,
      newSpread: newSpread,
    );
  }

  void _propagateToTop(final KeyStrokeData data, final List<KeyStrokeData> newSpread) {
    final CellCoords coords = data.cellCoords;
    final CellCoords newCoords = coords.getWithOffset(offsetY: 1);
    _propagateToNext(
      coords: coords,
      newCoords: newCoords,
      data: data,
      newSpread: newSpread,
    );
  }

  void _propagateToDown(final KeyStrokeData data, final List<KeyStrokeData> newSpread) {
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
    required final CellCoords newCoords,
    required final CellCoords coords,
    required final KeyStrokeData data,
    required final List<KeyStrokeData> newSpread,
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

  bool _canPropagate(final CellCoords newCoords) {
    final int x = newCoords.x;
    final int y = newCoords.y;

    return x >= 0 && x < sizeX && y >= 0 && y < sizeY;
  }
}
