import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/popup_cubit/popup_cubit.dart';
import 'package:rgb_app/cubits/popup_cubit/popup_state.dart';
import 'package:rgb_app/models/color_list_property.dart';
import 'package:rgb_app/widgets/color_picker/color_picker_renderer.dart';
import 'package:rgb_app/widgets/left_panel/add_generic_button/simple_button.dart';
import 'package:rgb_app/widgets/property_renderer/color_list_property/color_position.dart';

class ColorListPropertyRenderer extends StatefulWidget {
  final ColorListProperty property;

  ColorListPropertyRenderer({required this.property});

  @override
  State<ColorListPropertyRenderer> createState() => _ColorListPropertyRendererState();
}

class _ColorListPropertyRendererState extends State<ColorListPropertyRenderer> {
  final double width = 230;
  final double height = 220;

  late PopupCubit cubit;

  ColorListProperty get property => widget.property;

  List<Color> get value => property.value;

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
      padding: const EdgeInsets.only(left: 23.0),
      child: SizedBox(
        width: 200,
        child: Wrap(
          children: <Widget>[
            ...colorPositions,
            SimpleButton(onTap: addColor),
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
            property.value = value;
            property.notify();
          },
        );
      },
    );
  }

  void addColor() {
    setState(() {
      value.add(Colors.white);
      property.value = value;
    });
  }

  void deleteColor(int index) {
    setState(() {
      value.removeAt(index);
      property.value = value;
    });
  }
}
