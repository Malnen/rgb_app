import 'dart:async';
import 'dart:ffi';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/utils/assets_loader.dart';
import 'package:rxdart/rxdart.dart';
import 'package:win32/win32.dart';

typedef VoidFunctionPointer = Pointer<NativeFunction<Void Function()>>;
typedef VoidFunctionIntPointer = Pointer<NativeFunction<Void Function(Uint32)>>;
typedef NativeVoidFunction = NativeFunction<Void Function(VoidFunctionPointer callback)>;
typedef NotifierFunction = void Function(SendPort);

class UsbHotPlugHandler {
  static late DynamicLibrary _library;
  static late SendPort _sendPort;

  static void tryListen() {
    try {
      if(!kDebugMode) {
        _createIsolate();
      }
    } catch (_) {
      print(_);
    }
  }

  static void _createIsolate() async {
    final ReceivePort receivePort = ReceivePort();
    final Stream<Object?> broadcastReceivePort = receivePort.asBroadcastStream();
    await Isolate.spawn(_sendIsolate, receivePort.sendPort);
    broadcastReceivePort.debounceTime(Duration(seconds: 1)).listen(_onMessage);
  }

  static void _sendIsolate(SendPort sendPort) {
    _sendPort = sendPort;
    _init();
    _registerUsbConnectedCallback();
    _registerTestMessageCallback();
    _registerShouldKillCallback();
    _startListening();
  }

  static void _init() {
    _library = AssetsLoader.loadLibrary('USBHotPlug');
    final ReceivePort receivePort = ReceivePort();
    _sendPort.send(receivePort.sendPort);
  }

  static void _registerUsbConnectedCallback() {
    final String functionName = 'registerUsbConnectionCallback';
    final Pointer<NativeVoidFunction> pointer =
        _library.lookup<NativeFunction<Void Function(VoidFunctionPointer)>>(functionName);
    final void Function(VoidFunctionPointer) register = pointer.asFunction<void Function(VoidFunctionPointer)>();
    register(Pointer.fromFunction(_notify));
  }

  static void _registerShouldKillCallback() {
    final String functionName = 'registerShouldKill';
    final Pointer<NativeVoidFunction> pointer =
        _library.lookup<NativeFunction<Void Function(VoidFunctionPointer)>>(functionName);
    final void Function(VoidFunctionPointer) register = pointer.asFunction<void Function(VoidFunctionPointer)>();
    register(Pointer.fromFunction(_shouldKill));
  }

  static void _registerTestMessageCallback() {
    final String functionName = 'registerTestMessageCallback';
    final Pointer<NativeFunction<Void Function(Pointer<NativeFunction<Void Function(Uint32)>>)>> pointer =
        _library.lookup<NativeFunction<Void Function(VoidFunctionIntPointer)>>(functionName);
    final void Function(VoidFunctionIntPointer) register = pointer.asFunction<void Function(VoidFunctionIntPointer)>();
    register(Pointer.fromFunction(_testMessageHandler));
  }

  static void _testMessageHandler(int message) {
    print(message);
  }

  static void _notify() {
    _sendPort.send(null);
  }

  static void _shouldKill() {}

  static void _startListening() {
    final String functionName = 'startListening';
    final Pointer<NativeFunction<Void Function(Int32)>> pointer =
        _library.lookup<NativeFunction<Void Function(Int32)>>(functionName);
    final void Function(int) startListening = pointer.asFunction<void Function(int)>();
    final int windowHandle = GetForegroundWindow();
    startListening(windowHandle);
  }

  static void _onMessage(Object? value) {
    final DevicesBloc devicesBloc = GetIt.instance.get();
    final CheckDevicesConnectionStateEvent event = CheckDevicesConnectionStateEvent();
    devicesBloc.add(event);
  }
}
