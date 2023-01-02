import 'package:flutter/material.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/widgets/effect_property_renderer/numeric_property_renderer.dart';

class EffectPropertyRenderer extends StatefulWidget {
  final Property<Object> property;

  const EffectPropertyRenderer({required this.property});

  @override
  State<EffectPropertyRenderer> createState() => _EffectPropertyRendererState();
}

class _EffectPropertyRendererState extends State<EffectPropertyRenderer> {
  Property<Object> get property => widget.property;

  @override
  Widget build(final BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 80,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              property.name,
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ),
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
      case NumericProperty:
        return NumericPropertyRenderer(property: property as NumericProperty);
      default:
        throw Exception('Unsupported property type: $runtimeType');
    }
  }
}
