import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/enums/key_code.dart';

import 'key_event.dart';
import 'key_state.dart';
import 'package:keyboard_event/keyboard_event.dart' as ke;
import 'package:rgb_app/enums/key_code.dart';

class KeyBloc extends Bloc<KeyEvent, KeyState> {
  late ke.KeyboardEvent keyboardEvent;

  KeyBloc() : super(KeyInitialState()) {
    keyboardEvent = ke.KeyboardEvent();
    keyboardEvent.startListening(_startListening);
    on<KeyPressedEvent>(_onKeyPressedEvent);
    on<KeyReleasedEvent>(_onKeyReleasedEvent);
  }

  void _startListening(ke.KeyEvent keyEvent) {
    if (keyEvent.isKeyDown) {
      final KeyPressedEvent keyPressedEvent = KeyPressedEvent(
        keyCode: keyEvent.vkCode,
        keyName: KeyCodeExtension.name(keyEvent.vkCode),
      );
      add(keyPressedEvent);
    } else if (keyEvent.isKeyUP) {
      final KeyReleasedEvent keyReleasedEvent = KeyReleasedEvent(
        keyCode: keyEvent.vkCode,
        keyName: KeyCodeExtension.name(keyEvent.vkCode),
      );
      add(keyReleasedEvent);
    }
  }

  Future<void> _onKeyPressedEvent(
      KeyPressedEvent event, Emitter<KeyState> emit) async {
    final KeyPressedState state = KeyPressedState(
      keyCode: event.keyCode,
      keyName: event.keyName,
    );
    emit(state);
    print('down ${state.keyCode}- ${state.keyName}');
  }

  Future<void> _onKeyReleasedEvent(
      KeyReleasedEvent event, Emitter<KeyState> emit) async {
    final KeyReleasedState state = KeyReleasedState(
      keyCode: event.keyCode,
      keyName: event.keyName,
    );
    emit(state);
    print('up ${state.keyCode} - ${state.keyName}');
  }
}
