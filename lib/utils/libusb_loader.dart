import 'dart:ffi';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:libusb/libusb64.dart';

class LibusbLoader {
  static late Libusb _instance;

  static Libusb get getInstance => _instance;

  static void initLibusb() {
    _instance = Libusb(loadLibrary());
  }

  static DynamicLibrary loadLibrary() {
    final String assetsPath = _getAssetsPath();
    if (Platform.isWindows) {
      return DynamicLibrary.open('$assetsPath/libusb-1.0.dll');
    } else if (Platform.isMacOS) {
      return DynamicLibrary.open('$assetsPath/libusb-1.0.dylib');
    } else if (Platform.isLinux) {
      return DynamicLibrary.open('$assetsPath/libusb-1.0.so');
    }

    throw 'libusb dynamic library not found';
  }

  static String _getAssetsPath() {
    if (kDebugMode) {
      return 'assets';
    }

    List<String> folders = [
      'data',
      'flutter_assets',
      'assets',
    ];

    return folders.join('/');
  }
}
