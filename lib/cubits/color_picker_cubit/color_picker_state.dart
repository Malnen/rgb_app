import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/enums/color_picker_update_source.dart';

class ColorPickerState extends Equatable {
  final Color color;
  final ColorPickerUpdateSource source;

  ColorPickerState({
    required this.color,
    required this.source,
  });

  factory ColorPickerState.empty() {
    return ColorPickerState(
      color: Colors.black,
      source: ColorPickerUpdateSource.initial,
    );
  }

  @override
  List<Object> get props => <Object>[
        color,
        source,
      ];
}
