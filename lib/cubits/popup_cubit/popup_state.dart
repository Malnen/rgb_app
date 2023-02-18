import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PopupState extends Equatable {
  final bool show;
  final Offset padding;
  final Size size;
  final Widget? popupContent;
  final GlobalKey? parentKey;

  PopupState({
    required this.show,
    required this.padding,
    required this.size,
    this.popupContent,
    this.parentKey,
  });

  factory PopupState.empty() {
    return PopupState(
      show: false,
      padding: Offset.zero,
      size: Size(100, 100),
    );
  }

  factory PopupState.show({
    required Widget popupContent,
    required GlobalKey parentKey,
    Offset? padding,
    Size? size,
  }) {
    return PopupState(
      show: true,
      popupContent: popupContent,
      parentKey: parentKey,
      padding: padding ?? Offset.zero,
      size: size ?? Size(100, 100),
    );
  }

  @override
  List<Object?> get props => <Object?>[
        show,
        popupContent,
        parentKey,
        padding,
        size,
      ];
}
