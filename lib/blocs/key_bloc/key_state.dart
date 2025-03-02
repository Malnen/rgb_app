import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/blocs/key_bloc/key_state_type.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';

part '../../generated/blocs/key_bloc/key_state.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class KeyState with _$KeyState {
  @override
  final int keyCode;
  @override
  final String keyName;
  @override
  final KeyStateType type;
  @override
  final Key key;
  @override
  final KeyboardInterface? keyboardInterface;

  KeyState({
    required this.keyCode,
    required this.keyName,
    required this.type,
    required this.key,
    this.keyboardInterface,
  });

  factory KeyState.empty() => KeyState(
        keyCode: 0,
        keyName: '',
        type: KeyStateType.initial,
        key: UniqueKey(),
      );

  KeyState setKeyboard({KeyboardInterface? keyboardInterface}) => copyWith(keyboardInterface: keyboardInterface);
}
