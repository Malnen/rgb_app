import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
