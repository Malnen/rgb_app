import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class KeyState extends Equatable {}

class KeyInitialState extends KeyState {
  @override
  List<Object> get props => <Object>[];
}

class KeyPressedState extends KeyState {
  final int keyCode;
  final String keyName;
  final UniqueKey key;

  KeyPressedState({
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

class KeyReleasedState extends KeyState {
  final int keyCode;
  final String keyName;
  final UniqueKey key;

  KeyReleasedState({
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
