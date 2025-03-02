import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/enums/color_picker_update_source.dart';

part '../../generated/cubits/color_picker_cubit/color_picker_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class ColorPickerState with _$ColorPickerState {
  @override
  final Color color;
  @override
  final ColorPickerUpdateSource source;
  @override
  final double hue;
  @override
  final double saturation;
  @override
  final double value;

  ColorPickerState({
    required this.color,
    required this.source,
    required this.hue,
    required this.saturation,
    required this.value,
  });

  factory ColorPickerState.empty() => ColorPickerState(
        color: Colors.black,
        source: ColorPickerUpdateSource.initial,
        hue: 0,
        saturation: 1,
        value: 1,
      );

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
}
