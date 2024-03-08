import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_event/keyboard_event.dart' as ke;
import 'package:rgb_app/blocs/key_bloc/key_event.dart' as rgb_key_event;
import 'package:rgb_app/blocs/key_bloc/key_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_state_type.dart';
import 'package:rgb_app/enums/key_code.dart';

class KeyBloc extends Bloc<rgb_key_event.KeyEvent, KeyState> {
  late ke.KeyboardEvent keyboardEvent;

  KeyBloc() : super(KeyState.empty()) {
    keyboardEvent = ke.KeyboardEvent();
    keyboardEvent.startListening(_startListening);

    on<rgb_key_event.KeyPressedEvent>(_onKeyPressedEvent);
    on<rgb_key_event.KeyReleasedEvent>(_onKeyReleasedEvent);
    on<rgb_key_event.SetKeyboardDeviceEvent>(_onSetKeyboardDeviceEvent);
  }

  void _startListening(ke.KeyEvent keyEvent) {
    if (keyEvent.isKeyDown) {
      _onKeyDown(keyEvent);
    } else if (keyEvent.isKeyUP) {
      _onKeyUp(keyEvent);
    }
  }

  void _onKeyUp(ke.KeyEvent keyEvent) {
    final rgb_key_event.KeyReleasedEvent keyReleasedEvent = rgb_key_event.KeyReleasedEvent(
      keyCode: keyEvent.vkCode,
      keyName: KeyCodeExtension.name(keyEvent.vkCode),
      key: UniqueKey(),
    );
    add(keyReleasedEvent);
  }

  void _onKeyDown(ke.KeyEvent keyEvent) {
    final rgb_key_event.KeyPressedEvent keyPressedEvent = rgb_key_event.KeyPressedEvent(
      keyCode: keyEvent.vkCode,
      keyName: KeyCodeExtension.name(keyEvent.vkCode),
      key: UniqueKey(),
    );
    add(keyPressedEvent);
  }

  Future<void> _onKeyPressedEvent(final rgb_key_event.KeyPressedEvent event,
    final Emitter<KeyState> emit,
  ) async {
    final KeyState newState = state.copyWith(
      keyCode: event.keyCode,
      keyName: event.keyName,
      type: KeyStateType.pressed,
    );
    emit(newState);
  }

  Future<void> _onKeyReleasedEvent(final rgb_key_event.KeyReleasedEvent event,
    final Emitter<KeyState> emit,
  ) async {
    final KeyState newState = state.copyWith(
      keyCode: event.keyCode,
      keyName: event.keyName,
      type: KeyStateType.released,
    );
    emit(newState);
  }

  Future<void> _onSetKeyboardDeviceEvent(final rgb_key_event.SetKeyboardDeviceEvent event,
    final Emitter<KeyState> emit,
  ) async {
    final KeyState newState = state.setKeyboard(
      keyboardInterface: event.keyboardInterface,
    );
    emit(newState);
  }
}
