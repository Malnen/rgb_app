import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/key_bloc/key_state_type.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';

class KeyState extends Equatable {
  final int keyCode;
  final String keyName;
  final UniqueKey key;
  final KeyStateType type;
  final KeyboardInterface? keyboardInterface;

  KeyState({
    required this.keyCode,
    required this.keyName,
    required this.type,
    this.keyboardInterface,
    UniqueKey? key,
  }) : key = key ?? UniqueKey();

  factory KeyState.empty() {
    return KeyState(
      keyCode: 0,
      keyName: '',
      type: KeyStateType.initial,
    );
  }

  KeyState setKeyboard({KeyboardInterface? keyboardInterface}) {
    return KeyState(
      keyCode: keyCode,
      keyName: keyName,
      type: type,
      key: key,
      keyboardInterface: keyboardInterface,
    );
  }

  KeyState copyWith({
    int? keyCode,
    String? keyName,
    UniqueKey? key,
    KeyStateType? type,
    KeyboardInterface? keyboardInterface,
  }) {
    return KeyState(
      keyCode: keyCode ?? this.keyCode,
      keyName: keyName ?? this.keyName,
      type: type ?? this.type,
      key: key ?? this.key,
      keyboardInterface: keyboardInterface ?? this.keyboardInterface,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        keyCode,
        key,
        keyName,
        type,
        keyboardInterface,
      ];
}
