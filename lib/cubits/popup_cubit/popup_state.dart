import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/cubits/popup_cubit/popup_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class PopupState with _$PopupState {
  @override
  final bool show;
  @override
  final Offset padding;
  @override
  final Size size;
  @override
  final Widget? popupContent;
  @override
  final GlobalKey? parentKey;

  const PopupState({
    required this.show,
    required this.padding,
    required this.size,
    this.popupContent,
    this.parentKey,
  });

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
