import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';

abstract class KeyEvent extends Equatable {}

class KeyPressedEvent extends KeyEvent {
  final int keyCode;
  final String keyName;
  final UniqueKey key;

  KeyPressedEvent({
    required this.keyCode,
    required this.keyName,
  }) : key = UniqueKey();

  @override
  List<Object> get props => <Object>[
        keyCode,
        key,
        keyName,
      ];
}

class KeyReleasedEvent extends KeyEvent {
  final int keyCode;
  final String keyName;
  final UniqueKey key;

  KeyReleasedEvent({
    required this.keyCode,
    required this.keyName,
  }) : key = UniqueKey();

  @override
  List<Object> get props => <Object>[
        keyCode,
        key,
        keyName,
      ];
}

class SetKeyboardDeviceEvent extends KeyEvent {
  final KeyboardInterface? keyboardInterface;

  SetKeyboardDeviceEvent({
    required this.keyboardInterface,
  });

  @override
  List<Object?> get props => <Object?>[
        keyboardInterface,
      ];
}
