import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';

class LibraryLoader{
  static DynamicLibrary loadLibrary(String name) {
    final String assetsPath = _getAssetsPath();
    if (Platform.isWindows) {
      return DynamicLibrary.open('$assetsPath/$name.dll');
    } else if (Platform.isMacOS) {
      return DynamicLibrary.open('$assetsPath/$name.dylib');
    } else if (Platform.isLinux) {
      return DynamicLibrary.open('$assetsPath/$name.so');
    }

    throw Exception('$name not found');
  }

  static String _getAssetsPath() {
    if (kDebugMode) {
      return 'assets';
    }

    final List<String> folders = <String>[
      'data',
      'flutter_assets',
      'assets',
    ];

    return folders.join('/');
  }
}