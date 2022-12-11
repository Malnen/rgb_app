import 'dart:ffi';

import 'package:rgb_app/utils/library_loader.dart';

typedef VoidFunctionPointer = Pointer<NativeFunction<Void Function()>>;
typedef NativeVoidFunction = NativeFunction<Void Function(VoidFunctionPointer callback)>;

class UsbHotPlugHandler {
  static late DynamicLibrary _library;

  static void init() {
    _library = LibraryLoader.loadLibrary('USBHotPlug');
  }

  static void tryRegisterUsbConnectedCallback() {
    try {
      _registerUsbConnectedCallback();
    } catch (_) {
      print(_);
    }
  }

  static void tryRegisterUsbDisconnectedCallback() {
    try {
      _registerUsbDisconnectedCallback();
    } catch (_) {
      print(_);
    }
  }

  static void tryListen() {
    try {
      _startListening();
    } catch (_) {
      print(_);
    }
  }

  static void _registerUsbConnectedCallback() {
    final String functionName = 'registerUsbConnectedCallback';
    final Pointer<NativeVoidFunction> pointer =
        _library.lookup<NativeFunction<Void Function(VoidFunctionPointer)>>(functionName);
    final void Function(VoidFunctionPointer callback) register =
        pointer.asFunction<void Function(VoidFunctionPointer)>();
    register(Pointer.fromFunction(_handleConnection));
  }

  static void _handleConnection() {
    print('Device connected');
  }

  static void _registerUsbDisconnectedCallback() {
    final String functionName = 'registerUsbDisconnectedCallback';
    final Pointer<NativeVoidFunction> pointer =
        _library.lookup<NativeFunction<Void Function(VoidFunctionPointer)>>(functionName);
    final void Function(VoidFunctionPointer callback) register =
        pointer.asFunction<void Function(VoidFunctionPointer)>();
    register(Pointer.fromFunction(_handleDisconnection));
  }

  static void _handleDisconnection() {
    print('Device disconnected');
  }

  static void _startListening() {
    final String functionName = 'startListening';
    final Pointer<NativeFunction<Void Function()>> pointer =
        _library.lookup<NativeFunction<Void Function()>>(functionName);
    final void Function() startListening = pointer.asFunction<void Function()>();
    startListening();
  }
}
