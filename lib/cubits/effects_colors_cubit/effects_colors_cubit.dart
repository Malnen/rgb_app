import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_state.dart';

class EffectsColorsCubit extends Cubit<EffectsColorsState> {
  List<List<Color>> get colors => state.colors;

  EffectsColorsCubit() : super(EffectsColorsState(colors: <List<Color>>[]));

  void updateColors(List<List<Color>> colors) {
    emitColors(colors);
  }

  void updateColorsSize(int sizeX, int sizeY) {
    final List<List<Color>> colors = List<List<Color>>.generate(
      sizeY,
      (int index) => List<Color>.generate(
        sizeX,
        (int index) => Colors.white,
      ),
    );
    emitColors(colors);
  }

  void emitColors(List<List<Color>> colors) {
    final EffectsColorsState state = EffectsColorsState(colors: colors);
    emit(state);
  }
}
