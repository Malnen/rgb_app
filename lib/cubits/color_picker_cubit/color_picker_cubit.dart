import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_state.dart';
import 'package:rgb_app/enums/color_picker_update_source.dart';

class ColorPickerCubit extends Cubit<ColorPickerState> {
  ColorPickerCubit(Color color)
      : super(
          ColorPickerState.fromColor(
            color: color,
            source: ColorPickerUpdateSource.initial,
          ),
        );

  void update(ColorPickerState state) => emit(state);
}
