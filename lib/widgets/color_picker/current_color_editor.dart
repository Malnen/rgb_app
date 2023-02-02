import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_cubit.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_state.dart';
import 'package:rgb_app/enums/color_picker_update_source.dart';
import 'package:rgb_app/widgets/numeric_field/numeric_field.dart';

class CurrentColorEditor extends StatefulWidget {
  @override
  State<CurrentColorEditor> createState() => _CurrentColorEditorState();
}

class _CurrentColorEditorState extends State<CurrentColorEditor> {
  late TextEditingController rController;
  late TextEditingController gController;
  late TextEditingController bController;
  late ColorPickerCubit colorPickerCubit;

  @override
  void initState() {
    super.initState();
    colorPickerCubit = context.read();
    rController = TextEditingController();
    gController = TextEditingController();
    bController = TextEditingController();
    colorPickerCubit.stream.listen(setValues);
    rController.addListener(emitNewColor);
    gController.addListener(emitNewColor);
    bController.addListener(emitNewColor);
  }

  void setValues(ColorPickerState state) {
    final ColorPickerUpdateSource source = state.source;
    if (source == ColorPickerUpdateSource.colorPicker) {
      final Color color = state.color;
      rController.text = color.red.toString();
      gController.text = color.green.toString();
      bController.text = color.blue.toString();
    }
  }

  void emitNewColor() {
    final int r = getCorrectValue(rController);
    final int g = getCorrectValue(gController);
    final int b = getCorrectValue(bController);
    final Color color = Color.fromARGB(255, r, g, b);
    final ColorPickerState newState = ColorPickerState(
      source: ColorPickerUpdateSource.textField,
      color: color,
    );
    colorPickerCubit.setColor(newState);
  }

  int getCorrectValue(TextEditingController controller) {
    final String text = controller.text;
    if (text.isEmpty) {
      return 0;
    }

    return int.parse(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        getNumericField('R', rController),
        getNumericField('G', gController),
        getNumericField('B', bController),
      ],
    );
  }

  Widget getNumericField(String label, TextEditingController textEditingController) {
    return NumericField(
      label: label,
      controller: textEditingController,
      maxValue: 255,
      minValue: 0,
      fontSize: 12,
      width: 50,
      margin: 4,
      height: 50,
    );
  }
}
