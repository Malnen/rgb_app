import 'dart:ffi';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';

import 'package:rgb_app/utils/library_loader.dart';
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
      _createIsolate();
    } catch (_) {
      print(_);
    }
  }

  static void _createIsolate() async {
    final ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(_sendIsolate, receivePort.sendPort);
    await for (final Object? message in receivePort) {
      print(message);
    }
  }

  static void _sendIsolate(final SendPort sendPort) {
    _sendPort = Isolate.current.controlPort;
    _init();
    _registerUsbConnectedCallback();
    _registerTestMessageCallback();
    _startListening();
  }

  static void _init() {
    _library = LibraryLoader.loadLibrary('USBHotPlug');
  }

  static void _registerUsbConnectedCallback() {
    final String functionName = 'registerUsbConnectionCallback';
    final Pointer<NativeVoidFunction> pointer =
        _library.lookup<NativeFunction<Void Function(VoidFunctionPointer)>>(functionName);
    final void Function(VoidFunctionPointer) register = pointer.asFunction<void Function(VoidFunctionPointer)>();
    register(Pointer.fromFunction(_notify));
  }

  static void _registerTestMessageCallback() {
    final String functionName = 'registerTestMessageCallback';
    final Pointer<NativeFunction<Void Function(Pointer<NativeFunction<Void Function(Uint32)>> p1)>> pointer =
        _library.lookup<NativeFunction<Void Function(VoidFunctionIntPointer)>>(functionName);
    final void Function(VoidFunctionIntPointer) register = pointer.asFunction<void Function(VoidFunctionIntPointer)>();
    register(Pointer.fromFunction(_testMessageHandler));
  }

  static void _testMessageHandler(final int message) {
    print(message);
  }

  static void _notify() {
    _sendPort.send(Random().nextInt(100));
  }

  static void _startListening() {
    final String functionName = 'startListening';
    final Pointer<NativeFunction<Void Function(Int32)>> pointer =
        _library.lookup<NativeFunction<Void Function(Int32)>>(functionName);
    final void Function(int) startListening = pointer.asFunction<void Function(int)>();
    final int windowHandle = GetForegroundWindow();
    startListening(windowHandle);
  }

  static void _onMessage() {
    final DevicesBloc devicesBloc = GetIt.instance.get();
    final CheckDevicesConnectionStateEvent event = CheckDevicesConnectionStateEvent();
    devicesBloc.add(event);
  }
}