import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:rgb_app/enums/key_code.dart';

class KeyboardKey extends Equatable {
  final int packetIndex;
  final int index;
  final KeyCode keyCode;
  final UniqueKey key;

  KeyboardKey({
    required this.packetIndex,
    required this.index,
    required this.keyCode,
  }) : key = UniqueKey();

  @override
  List<Object> get props => <Object>[
        packetIndex,
        index,
        keyCode,
        key,
      ];
}
