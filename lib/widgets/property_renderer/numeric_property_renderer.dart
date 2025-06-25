import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:rgb_app/enums/numeric_property_type.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/widgets/numeric_field/numeric_field.dart';

class NumericPropertyRenderer extends StatefulHookWidget {
  final NumericProperty property;

  const NumericPropertyRenderer({required this.property});

  @override
  State<NumericPropertyRenderer> createState() => _NumericPropertyRendererState();
}

class _NumericPropertyRendererState extends State<NumericPropertyRenderer> {
  late FocusNode focusNode;
  late TextEditingController controller;

  NumericProperty get property => widget.property;

  @override
  Widget build(BuildContext context) {
    focusNode = useFocusNode();
    controller = useTextEditingController(text: formatValue(property.value));
    useEffect(
      () {
        if (!focusNode.hasFocus) {
          final String formatted = formatValue(property.value);
          if (controller.text != formatted) {
            controller.text = formatted;
            controller.selection = TextSelection.collapsed(offset: controller.text.length);
          }
        }
        return null;
      },
      <Object?>[property.value],
    );
    useValueListenable(property);

    return switch (property.propertyType) {
      NumericPropertyType.slider => Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: Slider(
                value: property.value,
                max: property.max,
                min: property.min,
                onChanged: onChanged,
                activeColor: Colors.orange,
                inactiveColor: Colors.white,
              ),
            ),
            _getField(withName: false),
          ],
        ),
      NumericPropertyType.textField => _getField(),
    };
  }

  Padding _getField({bool withName = true}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: NumericField<double>(
        width: withName ? (12 * property.name.length).toDouble() : 75,
        minValue: property.min,
        maxValue: property.max,
        focusNode: focusNode,
        controller: controller,
        onSubmit: onChanged,
      ),
    );
  }

  void onChanged(double updatedValue) => setState(() {
        property.value = updatedValue;
        if (!focusNode.hasFocus) {
          controller.text = formatValue(updatedValue);
        }
      });

  String formatValue(double value) {
    final NumberFormat formatter = NumberFormat()
      ..minimumFractionDigits = 0
      ..maximumFractionDigits = property.precision;
    return formatter.format(value);
  }
}
