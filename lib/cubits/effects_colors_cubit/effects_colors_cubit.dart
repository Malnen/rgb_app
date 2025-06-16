import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_state.dart';

class EffectsColorsCubit extends Cubit<EffectsColorsState> {
  List<List<Color>> get colors => state.colors;

  EffectsColorsCubit() : super(EffectsColorsState.withRandomKey(colors: <List<Color>>[]));

  void updateColors(List<List<Color>> colors) => _emitColors(colors);

  void updateColorsSize(int sizeX, int sizeZ) {
    final List<List<Color>> colors = List<List<Color>>.generate(
      sizeZ,
      (int index) => List<Color>.generate(
        sizeX,
        (int index) => Colors.white,
      ),
    );
    _emitColors(colors);
  }

  void _emitColors(List<List<Color>> colors) {
    final EffectsColorsState state = EffectsColorsState.withRandomKey(colors: colors);
    emit(state);
  }
}
