import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/enums/color_picker_update_source.dart';

class ColorPickerState extends Equatable {
  final Color color;
  final ColorPickerUpdateSource source;
  final double hue;
  final double saturation;
  final double value;

  ColorPickerState({
    required this.color,
    required this.source,
    required this.hue,
    required this.saturation,
    required this.value,
  });

  factory ColorPickerState.empty() {
    return ColorPickerState(
      color: Colors.black,
      source: ColorPickerUpdateSource.initial,
      hue: 0,
      saturation: 1,
      value: 1,
    );
  }

  factory ColorPickerState.fromColor({
    required Color color,
    required ColorPickerUpdateSource source,
  }) {
    final HSVColor hsvColor = HSVColor.fromColor(color);

    return ColorPickerState(
      color: color,
      source: source,
      hue: hsvColor.hue,
      saturation: hsvColor.saturation,
      value: hsvColor.value,
    );
  }

  ColorPickerState withHue({
    required double hue,
    required ColorPickerUpdateSource source,
  }) {
    final HSVColor hsvColor = HSVColor.fromAHSV(1, hue, saturation, value);
    return ColorPickerState(
      color: hsvColor.toColor(),
      source: source,
      hue: hsvColor.hue,
      saturation: hsvColor.saturation,
      value: hsvColor.value,
    );
  }

  ColorPickerState withBrightness({
    required double saturation,
    required double value,
    required ColorPickerUpdateSource source,
  }) {
    final HSVColor hsvColor = HSVColor.fromAHSV(1, hue, saturation, value);
    return ColorPickerState(
      color: hsvColor.toColor(),
      source: source,
      hue: hsvColor.hue,
      saturation: hsvColor.saturation,
      value: hsvColor.value,
    );
  }

  @override
  List<Object> get props => <Object>[
        color,
        source,
        hue,
      ];
}
