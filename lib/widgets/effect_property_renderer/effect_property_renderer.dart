import 'package:flutter/material.dart';
import 'package:rgb_app/models/color_list_property.dart';
import 'package:rgb_app/models/color_property.dart' as color;
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/vector_property.dart';
import 'package:rgb_app/widgets/effect_property_renderer/color_list_property/color_list_property_renderer.dart';
import 'package:rgb_app/widgets/effect_property_renderer/color_property_renderer.dart';
import 'package:rgb_app/widgets/effect_property_renderer/numeric_property_renderer.dart';
import 'package:rgb_app/widgets/effect_property_renderer/option_property_renderer.dart';
import 'package:rgb_app/widgets/effect_property_renderer/vector_property_renderer.dart';

class EffectPropertyRenderer extends StatelessWidget {
  final Property<Object> property;
  final VoidCallback updateRenderer;

  const EffectPropertyRenderer({
    required this.property,
    required this.updateRenderer,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 100,
          constraints: BoxConstraints(
            maxHeight: 100,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Wrap(
              children: <Widget>[
                Text(
                  property.name,
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        _getProperRenderer(),
      ],
    );
  }

  Widget _getProperRenderer() {
    final Type runtimeType = property.runtimeType;
    switch (runtimeType) {
      case const (NumericProperty):
        return NumericPropertyRenderer(property: property as NumericProperty);
      case const (VectorProperty):
        return VectorPropertyRenderer(property: property as VectorProperty);
      case const (OptionProperty):
        return OptionPropertyRenderer(
          property: property as OptionProperty,
          updateRenderer: updateRenderer,
        );
      case const (ColorListProperty):
        return ColorListPropertyRenderer(property: property as ColorListProperty);
      case const (color.ColorProperty):
        return ColorPropertyRenderer(property: property as color.ColorProperty);
      default:
        throw Exception('Unsupported property type: $runtimeType');
    }
  }
}
