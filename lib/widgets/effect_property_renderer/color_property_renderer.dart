import 'package:flutter/material.dart';
import 'package:rgb_app/models/color_property.dart' as color;
import 'package:rgb_app/widgets/color_picker/color_picker_renderer.dart';

class ColorPropertyRenderer extends StatefulWidget {
  final color.ColorProperty property;

  ColorPropertyRenderer({required this.property});

  @override
  State<ColorPropertyRenderer> createState() => _ColorListPropertyRendererState();
}

class _ColorListPropertyRendererState extends State<ColorPropertyRenderer> {
  color.ColorProperty get property => widget.property;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 23.0),
      child: SizedBox(
        width: 280,
        child: ColorPickerRenderer(
          color: property.value,
          onColorChange: (Color newColor) {
            setState(
              () {
                property.value = newColor;
              },
            );
          },
        ),
      ),
    );
  }
}
