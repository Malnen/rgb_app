import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/blocs/key_bloc/key_state_type.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';

part '../../generated/blocs/key_bloc/key_state.freezed.dart';

@freezed
class KeyState with _$KeyState {
  const KeyState._();

  const factory KeyState({
    required int keyCode,
    required String keyName,
    required KeyStateType type,
    required Key key,
    KeyboardInterface? keyboardInterface,
  }) = _KeyState;

  factory KeyState.empty() => KeyState(
        keyCode: 0,
        keyName: '',
        type: KeyStateType.initial,
        key: UniqueKey(),
      );

  KeyState setKeyboard({KeyboardInterface? keyboardInterface}) => copyWith(keyboardInterface: keyboardInterface);
}
