import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rgb_app/text_input_formatters/min_max_text_input_formatter.dart';

class NumericField<T extends num> extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final double width;
  final double margin;
  final double? height;
  final double? fontSize;
  final T? minValue;
  final T? maxValue;
  final FocusNode? focusNode;
  final void Function(T)? onSubmit;

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
    this.onSubmit,
  });

  @override
  State<NumericField<T>> createState() => _NumericFieldState<T>();
}

class _NumericFieldState<T extends num> extends State<NumericField<T>> {
  FocusNode? get focusNode => widget.focusNode;

  TextEditingController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    focusNode?.addListener(() {
      if (!(focusNode?.hasFocus ?? false)) {
        onSubmit(controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      margin: EdgeInsets.all(widget.margin),
      child: TextField(
        onSubmitted: onSubmit,
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          if (widget.minValue != null && widget.maxValue != null)
            MinMaxTextInputFormatter<T>(
              min: widget.minValue!,
              max: widget.maxValue!,
            ),
        ],
        // Only nu
        style: TextStyle(
          color: Colors.white,
          fontSize: widget.fontSize,
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
          label: Text(widget.label),
          labelStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void onSubmit(String value) {
    final T? parsedValue = parseValue(value);
    if (parsedValue == null) {
      controller.text = '0';
      widget.onSubmit?.call(0 as T);
    } else {
      widget.onSubmit?.call(parsedValue);
    }
  }

  T? parseValue(String value) {
    if (T == double) {
      return double.tryParse(value) as T;
    }

    return int.tryParse(value) as T;
  }
}
