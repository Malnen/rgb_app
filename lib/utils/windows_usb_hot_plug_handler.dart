import 'dart:ffi';

typedef VoidFunctionPointer = Pointer<NativeFunction<Void Function()>>;
typedef NativeVoidFunction = NativeFunction<Void Function(VoidFunctionPointer callback)>;

class WindowsUsbHotPlugHandler {
  static late DynamicLibrary _library;

  static void init() {
    _library = DynamicLibrary.open('assets/UsbHotPlug.dll');
  }

  static void tryRegisterUsbConnectedCallback() {
    try {
      _registerUsbConnectedCallback();
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
}
