import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_event/keyboard_event.dart' as ke;
import 'package:rgb_app/blocs/key_bloc/key_event.dart';
import 'package:rgb_app/blocs/key_bloc/key_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_state_type.dart';
import 'package:rgb_app/enums/key_code.dart';

class KeyBloc extends Bloc<KeyEvent, KeyState> {
  late ke.KeyboardEvent keyboardEvent;

  KeyBloc() : super(KeyState.empty()) {
    keyboardEvent = ke.KeyboardEvent();
    keyboardEvent.startListening(_startListening);

    on<KeyPressedEvent>(_onKeyPressedEvent);
    on<KeyReleasedEvent>(_onKeyReleasedEvent);
    on<SetKeyboardDeviceEvent>(_onSetKeyboardDeviceEvent);
  }

  void _startListening(ke.KeyEvent keyEvent) {
    if (keyEvent.isKeyDown) {
      _onKeyDown(keyEvent);
    } else if (keyEvent.isKeyUP) {
      _onKeyUp(keyEvent);
    }
  }

  void _onKeyUp(ke.KeyEvent keyEvent) {
    final KeyReleasedEvent keyReleasedEvent = KeyReleasedEvent(
      keyCode: keyEvent.vkCode,
      keyName: KeyCodeExtension.name(keyEvent.vkCode),
    );
    add(keyReleasedEvent);
  }

  void _onKeyDown(ke.KeyEvent keyEvent) {
    final KeyPressedEvent keyPressedEvent = KeyPressedEvent(
      keyCode: keyEvent.vkCode,
      keyName: KeyCodeExtension.name(keyEvent.vkCode),
    );
    add(keyPressedEvent);
  }

  Future<void> _onKeyPressedEvent(
    final KeyPressedEvent event,
    final Emitter<KeyState> emit,
  ) async {
    final KeyState newState = state.copyWith(
      keyCode: event.keyCode,
      keyName: event.keyName,
      type: KeyStateType.pressed,
    );
    emit(newState);
  }

  Future<void> _onKeyReleasedEvent(
    final KeyReleasedEvent event,
    final Emitter<KeyState> emit,
  ) async {
    final KeyState newState = state.copyWith(
      keyCode: event.keyCode,
      keyName: event.keyName,
      type: KeyStateType.released,
    );
    emit(newState);
  }

  Future<void> _onSetKeyboardDeviceEvent(
    final SetKeyboardDeviceEvent event,
    final Emitter<KeyState> emit,
  ) async {
    final KeyState newState = state.setKeyboard(
      keyboardInterface: event.keyboardInterface,
    );
    emit(newState);
  }
}
