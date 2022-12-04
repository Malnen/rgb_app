import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/key_bloc/key_state_type.dart';

class KeyState extends Equatable {
  final int keyCode;
  final String keyName;
  final UniqueKey key;
  final KeyStateType type;
  final int offsetX;
  final int offsetY;

  KeyState({
    required this.keyCode,
    required this.keyName,
    required this.type,
    this.offsetX = 0,
    this.offsetY = 0,
    final UniqueKey? key,
  }) : key = key ?? UniqueKey();

  factory KeyState.empty() {
    return KeyState(
      keyCode: 0,
      keyName: '',
      type: KeyStateType.initial,
    );
  }

  KeyState copyWith({
    final int? keyCode,
    final String? keyName,
    final UniqueKey? key,
    final KeyStateType? type,
    final int? offsetX,
    final int? offsetY,
  }) {
    return KeyState(
      keyCode: keyCode ?? this.keyCode,
      keyName: keyName ?? this.keyName,
      type: type ?? this.type,
      key: key ?? this.key,
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
    );
  }

  @override
  List<Object> get props => <Object>[
        keyCode,
        key,
        keyName,
        type,
        offsetY,
        offsetX,
      ];
}
