import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/cubits/popup_cubit/popup_state.freezed.dart';

@freezed
class PopupState with _$PopupState {
  const factory PopupState({
    required bool show,
    required Offset padding,
    required Size size,
    Widget? popupContent,
    GlobalKey? parentKey,
  }) = _PopupState;

  factory PopupState.empty() => const PopupState(
        show: false,
        padding: Offset.zero,
        size: Size(100, 100),
      );

  factory PopupState.show({
    required Widget popupContent,
    required GlobalKey parentKey,
    Offset? padding,
    Size? size,
  }) =>
      PopupState(
        show: true,
        popupContent: popupContent,
        parentKey: parentKey,
        padding: padding ?? Offset.zero,
        size: size ?? Size(100, 100),
      );
}
