import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_cubit.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_state.dart';
import 'package:rgb_app/enums/color_picker_update_source.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/widgets/numeric_field/numeric_field.dart';

class CurrentColorEditor extends StatefulWidget {
  @override
  State<CurrentColorEditor> createState() => _CurrentColorEditorState();
}

class _CurrentColorEditorState extends State<CurrentColorEditor> {
  late TextEditingController rController;
  late TextEditingController gController;
  late TextEditingController bController;
  late FocusNode rFocusNode;
  late FocusNode gFocusNode;
  late FocusNode bFocusNode;
  late ColorPickerCubit colorPickerCubit;

  @override
  void initState() {
    super.initState();
    colorPickerCubit = context.read();
    rController = TextEditingController();
    gController = TextEditingController();
    bController = TextEditingController();
    rFocusNode = FocusNode();
    gFocusNode = FocusNode();
    bFocusNode = FocusNode();
    colorPickerCubit.stream.listen(setValues);
    rController.addListener(emitNewColor);
    gController.addListener(emitNewColor);
    bController.addListener(emitNewColor);

    setValues(colorPickerCubit.state);
  }

  void setValues(ColorPickerState state) {
    final ColorPickerUpdateSource source = state.source;
    if (source != ColorPickerUpdateSource.textField) {
      final Color color = state.color;
      rController.text = color.redInt.toString();
      gController.text = color.greenInt.toString();
      bController.text = color.blueInt.toString();
    }
  }

  void emitNewColor() {
    final int r = getCorrectValue(rController);
    final int g = getCorrectValue(gController);
    final int b = getCorrectValue(bController);
    final Color color = Color.fromARGB(255, r, g, b);
    final ColorPickerState currentState = colorPickerCubit.state;
    final Color currentColor = currentState.color;
    final bool hasDifferentColor = currentColor.redInt != r || currentColor.greenInt != g || currentColor.blueInt != b;
    final bool hasFocus = rFocusNode.hasFocus || gFocusNode.hasFocus || bFocusNode.hasFocus;
    if (hasDifferentColor && hasFocus) {
      final ColorPickerState newState = ColorPickerState.fromColor(
        source: ColorPickerUpdateSource.textField,
        color: color,
      );
      colorPickerCubit.update(newState);
    }
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
    return Row(
      children: <Widget>[
        getNumericField(
          label: 'R',
          textEditingController: rController,
          focusNode: rFocusNode,
        ),
        getNumericField(
          label: 'G',
          textEditingController: gController,
          focusNode: gFocusNode,
        ),
        getNumericField(
          label: 'B',
          textEditingController: bController,
          focusNode: bFocusNode,
        ),
      ],
    );
  }

  Widget getNumericField({
    required String label,
    required TextEditingController textEditingController,
    required FocusNode focusNode,
  }) {
    return NumericField<int>(
      label: label,
      focusNode: focusNode,
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
