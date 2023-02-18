import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/popup_cubit/popup_state.dart';

class PopupCubit extends Cubit<PopupState> {
  PopupCubit() : super(PopupState.empty());

  void show({
    required Widget popupContent,
    required GlobalKey parentKey,
    Offset? padding,
    Size? size,
  }) {
    final PopupState popupState = PopupState.show(
      popupContent: popupContent,
      parentKey: parentKey,
      padding: padding,
      size: size,
    );
    emit(popupState);
  }

  void hide() => emit(PopupState.empty());
}
