import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/enums/key_code.dart';

part '../generated/devices/keyboard_key.freezed.dart';

@freezed
class KeyboardKey with _$KeyboardKey {
  const factory KeyboardKey({
    required int packetIndex,
    required int index,
    required KeyCode keyCode,
    required UniqueKey key,
  }) = _KeyboardKey;

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
