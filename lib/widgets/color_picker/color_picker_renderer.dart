import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_cubit.dart';
import 'package:rgb_app/widgets/color_picker/brightness_picker.dart';
import 'package:rgb_app/widgets/color_picker/current_color_editor.dart';
import 'package:rgb_app/widgets/color_picker/current_color_presenter.dart';
import 'package:rgb_app/widgets/color_picker/hue_picker.dart';

class ColorPickerRenderer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ColorPickerCubit>(
      create: (BuildContext context) => ColorPickerCubit(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CurrentColorPresenter(),
          BrightnessPicker(),
          HuePicker(),
          CurrentColorEditor(),
        ],
      ),
    );
  }
}
