import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_state.dart';

class ColorPickerCubit extends Cubit<ColorPickerState> {
  ColorPickerCubit() : super(ColorPickerState.empty());

  void update(ColorPickerState state) => emit(state);
}
