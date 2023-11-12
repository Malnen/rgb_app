import 'package:flutter/material.dart';
import 'package:rgb_app/enums/numeric_property_type.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/widgets/numeric_field/numeric_field.dart';

class NumericPropertyRenderer extends StatefulWidget {
  final NumericProperty property;

  const NumericPropertyRenderer({required this.property});

  @override
  State<NumericPropertyRenderer> createState() => _NumericPropertyRendererState();
}

class _NumericPropertyRendererState extends State<NumericPropertyRenderer> {
  late FocusNode focusNode;

  NumericProperty get property => widget.property;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    switch (property.propertyType) {
      case NumericPropertyType.slider:
        return Slider(
          value: property.currentValue,
          max: property.max,
          min: property.min,
          onChanged: onChanged,
          activeColor: Colors.orange,
          inactiveColor: Colors.white,
        );
      case NumericPropertyType.textField:
        final String name = property.name;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: NumericField<double>(
            label: name,
            width: (12 * name.length).toDouble(),
            minValue: property.min,
            maxValue: property.max,
            focusNode: focusNode,
            controller: TextEditingController(
              text: property.currentValue.toString(),
            ),
            onSubmit: onChanged,
          ),
        );
    }
  }

  void onChanged(double updatedValue) {
    setState(() {
      property.value = updatedValue;
    });
  }
}
