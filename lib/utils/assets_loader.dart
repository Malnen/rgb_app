import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class AssetsLoader {
  static String getAssetPath({required String name, bool withAbsolutePath = false}) {
    final String assetsPath = _getCorrectAssetsPath(withAbsolutePath: withAbsolutePath);
    return '$assetsPath\\$name';
  }

  static String _getCorrectAssetsPath({bool withAbsolutePath = false}) {
    final String assetsPath = _getAssetsPath();
    if (!withAbsolutePath) {
      return assetsPath;
    }

    final String absolutePath = _getAbsolutePath();
    return '$absolutePath\\$assetsPath';
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

    return folders.join('\\');
  }

  static String _getAbsolutePath() {
    final String scriptPath = Platform.script.toFilePath();
    return dirname(scriptPath);
  }
}
