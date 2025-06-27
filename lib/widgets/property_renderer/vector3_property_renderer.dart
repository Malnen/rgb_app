import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/vector3_property.dart';
import 'package:rgb_app/widgets/property_renderer/numeric_property_renderer.dart';
import 'package:rgb_app/widgets/property_renderer/property_wrapper.dart';

class Vector3PropertyRenderer extends HookWidget {
  final Vector3Property property;

  const Vector3PropertyRenderer({required this.property});

  @override
  Widget build(BuildContext context) {
    useValueListenable(property);
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildField(property.x),
              _buildField(property.y),
              _buildField(property.z),
            ],
          ),
        ),
        Positioned(
          left: 12,
          top: 0,
          child: Container(
            color: Theme.of(context).colorScheme.surface,
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(property.name),
          ),
        ),
      ],
    );
  }

  Widget _buildField(NumericProperty axisProperty) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: PropertyWrapper(
          property: axisProperty,
          child: NumericPropertyRenderer(property: axisProperty),
        ),
      );
}
