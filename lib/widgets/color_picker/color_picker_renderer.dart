import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_cubit.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_state.dart';
import 'package:rgb_app/widgets/color_picker/brightness_picker.dart';
import 'package:rgb_app/widgets/color_picker/current_color_editor.dart';
import 'package:rgb_app/widgets/color_picker/current_color_presenter.dart';
import 'package:rgb_app/widgets/color_picker/hue_picker.dart';

class ColorPickerRenderer extends StatelessWidget {
  final Color color;
  final void Function(Color) onColorChange;

  const ColorPickerRenderer({
    required this.color,
    required this.onColorChange,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ColorPickerCubit>(
      create: (BuildContext context) => ColorPickerCubit(color),
      child: BlocListener<ColorPickerCubit, ColorPickerState>(
        child: Row(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CurrentColorPresenter(),
                    ),
                    BrightnessPicker(),
                  ],
                ),
                CurrentColorEditor(),
              ],
            ),
            HuePicker(),
          ],
        ),
        listener: (BuildContext context, ColorPickerState state) => onColorChange(state.color),
      ),
    );
  }
}
