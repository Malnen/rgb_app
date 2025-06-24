import 'package:flutter/material.dart';
import 'package:rgb_app/models/color_list_property.dart';
import 'package:rgb_app/models/color_property.dart' as color;
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/vector3_property.dart';
import 'package:rgb_app/models/vector_property.dart';
import 'package:rgb_app/widgets/property_renderer/color_list_property/color_list_property_renderer.dart';
import 'package:rgb_app/widgets/property_renderer/color_property_renderer.dart';
import 'package:rgb_app/widgets/property_renderer/numeric_property_renderer.dart';
import 'package:rgb_app/widgets/property_renderer/option_property_renderer.dart';
import 'package:rgb_app/widgets/property_renderer/property_wrapper.dart';
import 'package:rgb_app/widgets/property_renderer/vector3_property_renderer.dart';
import 'package:rgb_app/widgets/property_renderer/vector_property_renderer.dart';

class PropertyRenderer extends StatelessWidget {
  final Property<Object> property;
  final VoidCallback updateRenderer;

  const PropertyRenderer({
    required this.property,
    required this.updateRenderer,
  });

  @override
  Widget build(BuildContext context) => PropertyWrapper(
        property: property,
        child: switch (property) {
          final NumericProperty property => NumericPropertyRenderer(property: property),
          final VectorProperty property => VectorPropertyRenderer(property: property),
          final Vector3Property property => Vector3PropertyRenderer(property: property),
          final OptionProperty property => OptionPropertyRenderer(
              property: property,
              updateRenderer: updateRenderer,
            ),
          final ColorListProperty property => ColorListPropertyRenderer(property: property),
          final color.ColorProperty property => ColorPropertyRenderer(property: property),
          _ => throw Exception('Unsupported property type: ${property.runtimeType}'),
        },
      );
}
