import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';

part '../../generated/blocs/key_bloc/key_event.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
abstract class KeyEvent with _$KeyEvent {
  const factory KeyEvent.keyPressed({
    required int keyCode,
    required String keyName,
    required Key key,
  }) = KeyPressedEvent;

  const factory KeyEvent.keyReleased({
    required int keyCode,
    required String keyName,
    required Key key,
  }) = KeyReleasedEvent;

  const factory KeyEvent.setKeyboardDevice({
    required KeyboardInterface? keyboardInterface,
    required Key key,
  }) = SetKeyboardDeviceEvent;
}
