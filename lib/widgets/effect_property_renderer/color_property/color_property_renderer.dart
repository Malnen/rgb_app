import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/popup_cubit/popup_cubit.dart';
import 'package:rgb_app/cubits/popup_cubit/popup_state.dart';
import 'package:rgb_app/models/colors_property.dart';
import 'package:rgb_app/widgets/color_picker/color_picker_renderer.dart';
import 'package:rgb_app/widgets/effect_property_renderer/color_property/color_position.dart';
import 'package:rgb_app/widgets/left_panel/add_generic_button/add_button.dart';

class ColorPropertyRenderer extends StatefulWidget {
  final ColorsProperty property;

  ColorPropertyRenderer({required this.property});

  @override
  State<ColorPropertyRenderer> createState() => _ColorPropertyRendererState();
}

class _ColorPropertyRendererState extends State<ColorPropertyRenderer> {
  final double width = 230;
  final double height = 220;

  late PopupCubit cubit;

  List<Color> get value => widget.property.value;

  @override
  void initState() {
    super.initState();
    cubit = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<Widget> colors = getColors();
    final List<Widget> colorPositions = colors.toList();
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: SizedBox(
        width: 200,
        child: Wrap(
          children: <Widget>[
            ...colorPositions,
            AddButton(onTap: addColor),
          ],
        ),
      ),
    );
  }

  Iterable<Widget> getColors() sync* {
    for (int i = 0; i < value.length; i++) {
      yield* getColor(i);
    }
  }

  Iterable<Widget> getColor(int index) sync* {
    yield ColorPosition(
      onTap: onPressed,
      color: value[index],
      index: index,
      onDelete: () => deleteColor(index),
    );
  }

  void onPressed(GlobalKey globalKey, int index) {
    final PopupState state = cubit.state;
    state.show
        ? cubit.hide()
        : cubit.show(
            popupContent: getPopupContent(index),
            parentKey: globalKey,
            padding: Offset(-width / 2, -height),
            size: Size(width, height),
          );
  }

  Widget getPopupContent(int index) {
    return ColorPickerRenderer(
      color: value[index],
      onColorChange: (Color newColor) {
        setState(
          () {
            value[index] = newColor;
          },
        );
      },
    );
  }

  void addColor() {
    setState(() {
      value.add(Colors.white);
    });
  }

  void deleteColor(int index) {
    setState(() {
      value.removeAt(index);
    });
  }
}
