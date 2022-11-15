import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

import 'effect.dart';

class RainbowWaveEffect extends Effect {
  double size = 15;
  double speed = 2.5;
  double value = 1;
  int direction = -1;

  RainbowWaveEffect();

  @override
  void update() {
    final EffectState state = effectBloc.state;
    final EffectGridData effectGridData = state.effectGridData;
    final List<List<Color>> colors = effectBloc.colors;
    final int sizeX = effectGridData.sizeX;
    final int sizeY = effectGridData.sizeY;
    if (colors.isNotEmpty) {
      _setColors(sizeX, sizeY, colors);
    }

    value += speed * direction;
    value = value % 360;
  }

  void _setColors(int sizeX, int sizeY, List<List<Color>> colors) {
    for (int i = 0; i < sizeX; i++) {
      _setColor(i, sizeY, colors);
    }
  }

  void _setColor(int i, int sizeY, List<List<Color>> colors) {
    final double hue = (i * size + value) % 360;
    final HSVColor hsv = HSVColor.fromAHSV(1, hue, 1, 1);
    for (int j = 0; j < sizeY; j++) {
      try {
        colors[j][i] = hsv.toColor();
      } finally {}
    }
  }
}
