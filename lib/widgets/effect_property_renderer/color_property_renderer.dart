import 'package:flutter/material.dart';
import 'package:rgb_app/models/colors_property.dart';
import 'package:rgb_app/widgets/color_picker/color_picker_renderer.dart';

class ColorPropertyRenderer extends StatelessWidget {
  final ColorsProperty property;

  const ColorPropertyRenderer({required this.property});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: ColorPickerRenderer(),
    );
  }
}
