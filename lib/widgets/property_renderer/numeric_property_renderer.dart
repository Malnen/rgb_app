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
  Widget build(BuildContext context) => switch (property.propertyType) {
        NumericPropertyType.slider => Slider(
            value: property.value,
            max: property.max,
            min: property.min,
            onChanged: onChanged,
            activeColor: Colors.orange,
            inactiveColor: Colors.white,
          ),
        NumericPropertyType.textField => Padding(
            padding: const EdgeInsets.all(8.0),
            child: NumericField<double>(
              label: property.name,
              width: (12 * property.name.length).toDouble(),
              minValue: property.min,
              maxValue: property.max,
              focusNode: focusNode,
              controller: TextEditingController(
                text: property.value.toString(),
              ),
              onSubmit: onChanged,
            ),
          ),
      };

  void onChanged(double updatedValue) => setState(() {
        property.value = updatedValue;
      });
}
