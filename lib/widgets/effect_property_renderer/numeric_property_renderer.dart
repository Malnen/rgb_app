import 'package:flutter/material.dart';
import 'package:rgb_app/models/numeric_property.dart';

class NumericPropertyRenderer extends StatefulWidget {
  final NumericProperty property;

  const NumericPropertyRenderer({required this.property});

  @override
  State<NumericPropertyRenderer> createState() => _NumericPropertyRendererState();
}

class _NumericPropertyRendererState extends State<NumericPropertyRenderer> {
  NumericProperty get property => widget.property;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: property.currentValue,
      max: property.max,
      min: property.min,
      onChanged: onChanged,
      activeColor: Colors.orange,
      inactiveColor: Colors.white,
    );
  }

  void onChanged(double updatedValue) {
    setState(() {
      property.value = updatedValue;
    });
  }
}
