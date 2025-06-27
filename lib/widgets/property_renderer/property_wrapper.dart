import 'package:flutter/material.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/vector3_property.dart';

class PropertyWrapper extends StatelessWidget {
  final Property<Object> property;
  final Widget child;

  const PropertyWrapper({
    required this.property,
    required this.child,
    super.key,
  });

  bool get shouldRenderName => property is! Vector3Property;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: <Widget>[
        if (shouldRenderName)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              property.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        child,
      ],
    );
  }
}
