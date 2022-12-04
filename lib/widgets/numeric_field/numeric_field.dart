import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const NumericField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(final BuildContext context) {
    return Container(
      width: 50,
      margin: EdgeInsets.all(10),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        // Only nu
        style: TextStyle(
          color: Colors.white,
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
