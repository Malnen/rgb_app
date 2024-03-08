import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rgb_app/models/color_property.dart' as color;
import 'package:rgb_app/widgets/color_picker/color_picker_renderer.dart';

class ColorPropertyRenderer extends HookWidget {
  final color.ColorProperty property;

  ColorPropertyRenderer({required this.property});

  @override
  Widget build(BuildContext context) {
    final Color value = useValueListenable(property);
    return Padding(
      padding: const EdgeInsets.only(left: 23.0),
      child: SizedBox(
        width: 280,
        child: ColorPickerRenderer(
          color: value,
          onColorChange: (Color newColor) => property.value = newColor,
        ),
      ),
    );
  }
}
