import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rgb_app/text_input_formatters/min_max_text_input_formatter.dart';

class NumericField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double width;
  final double margin;
  final double? height;
  final double? fontSize;
  final int? minValue;
  final int? maxValue;
  final FocusNode? focusNode;

  const NumericField({
    required this.label,
    required this.controller,
    this.width = 50,
    this.margin = 0,
    this.height,
    this.fontSize,
    this.minValue,
    this.maxValue,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.all(margin),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          if (minValue != null && maxValue != null)
            MinMaxTextInputFormatter(
              min: minValue!,
              max: maxValue!,
            ),
        ],
        // Only nu
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
        ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.white,
              width: 2.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.orange,
              width: 2.5,
            ),
          ),
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          label: Text(label),
          labelStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
