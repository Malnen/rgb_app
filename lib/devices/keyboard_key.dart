import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/enums/key_code.dart';
import 'package:rgb_app/json_converters/unique_key_converter.dart';

part '../generated/devices/keyboard_key.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class KeyboardKey with _$KeyboardKey {
  @override
  final int packetIndex;
  @override
  final int index;
  @override
  final KeyCode keyCode;
  @override
  @UniqueKeyConverter()
  final UniqueKey key;

  KeyboardKey({
    required this.packetIndex,
    required this.index,
    required this.keyCode,
    required this.key,
  });

  factory KeyboardKey.withRandomKey({
    required int packetIndex,
    required int index,
    required KeyCode keyCode,
  }) =>
      KeyboardKey(
        packetIndex: packetIndex,
        index: index,
        keyCode: keyCode,
        key: UniqueKey(),
      );
}
