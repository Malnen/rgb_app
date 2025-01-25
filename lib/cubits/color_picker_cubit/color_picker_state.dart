import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/enums/color_picker_update_source.dart';

part '../../generated/cubits/color_picker_cubit/color_picker_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class ColorPickerState with _$ColorPickerState {
  ColorPickerState._();

  factory ColorPickerState({
    required Color color,
    required ColorPickerUpdateSource source,
    required double hue,
    required double saturation,
    required double value,
  }) = _ColorPickerState;

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
