import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_state.dart';
import 'package:rgb_app/models/color_list.dart';

class EffectsColorsCubit extends Cubit<EffectsColorsState> {
  ColorList get colors => state.colors;

  EffectsColorsCubit()
      : super(
          EffectsColorsState(
            colors: ColorList(width: 0, height: 0),
            key: UniqueKey(),
            usedIndexes: <int>{},
          ),
        );

  void updateColors(ColorList colors) => _emitColors(colors);

  void updateColorsSize(int sizeX, int sizeZ) {
    final ColorList colors = ColorList(width: sizeX, height: sizeZ);
    _emitColors(colors);
  }

  void updateUsedIndexes(Set<int> usedIndexes) {
    emit(state.copyWith(usedIndexes: usedIndexes));
  }

  void _emitColors(ColorList colors) {
    emit(state.copyWith(key: UniqueKey(), colors: colors));
  }
}
