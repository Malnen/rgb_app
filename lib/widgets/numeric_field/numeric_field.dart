import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rgb_app/text_input_formatters/min_max_text_input_formatter.dart';

class NumericField<T extends num> extends StatefulWidget {
  final String? label;
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
    required this.controller,
    this.label,
    double? width,
    this.margin = 0,
    this.height,
    this.fontSize,
    this.minValue,
    this.maxValue,
    this.focusNode,
    this.onSubmit,
  }) : width = width ?? 50;

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
          if (widget.minValue != null && widget.maxValue != null) MinMaxTextInputFormatter<T>(),
        ],
        // Only nu
        style: TextStyle(
          fontSize: widget.fontSize,
        ),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: 2.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2.5,
            ),
          ),
          hintStyle: TextStyle(),
          label: widget.label != null ? Text(widget.label!) : null,
        ),
      ),
    );
  }

  void onSubmit(String value) {
    final T parsedValue = parseValue(value);
    widget.onSubmit?.call(parsedValue);
  }

  T parseValue(String value) {
    if (T == double) {
      return double.tryParse(value) as T? ?? 0 as T;
    }

    return int.tryParse(value) as T? ?? 0 as T;
  }
}
