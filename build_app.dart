import 'dart:io';

import 'package:path/path.dart' as path;

void main() {
  copyAssets();
  generateFiles();
  runFlutterBuildWindows();
}

void copyAssets() {
  print('Copying rgbAppService');
  final String sourceDir = 'C:/Users/malne/source/repos/RgbAppService/RgbAppService/bin/Release/net7.0';
  final String destinationDir = 'assets/rgbAppService';
  Directory(destinationDir).createSync(recursive: true);
  copyDirectory(Directory(sourceDir), Directory(destinationDir));
  print('Copied');
}

void generateFiles() {
  print('Generating files...');
  final ProcessResult result = executeCommand(<String>[
    'pub',
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
    'models:generated',
  ]);
  if (result.exitCode == 0) {
    print('Flutter build windows completed successfully.');
    print('Done');
  } else {
    print('Error: Flutter build windows failed. Exit code: ${result.exitCode}');
    print('Stderr: ${result.stderr}');
  }
}

void copyDirectory(Directory source, Directory destination) {
  source.listSync().forEach((FileSystemEntity entity) {
    if (entity is File) {
      final String fileName = path.basename(entity.path);
      final String destinationPath = path.join(destination.path, fileName);
      entity.copySync(destinationPath);
    } else if (entity is Directory) {
      final String dirName = path.basename(entity.path);
      final String destinationPath = path.join(destination.path, dirName);
      final Directory newDestination = Directory(destinationPath);
      newDestination.createSync(recursive: true);
      copyDirectory(entity, newDestination);
    }
  });
}

void runFlutterBuildWindows() {
  print('Running flutter build...');
  final ProcessResult result = executeCommand(<String>['build', 'windows']);
  if (result.exitCode == 0) {
    print('Done');
  } else {
    print('Error, exit code: ${result.exitCode}');
    print('Stderr: ${result.stderr}');
  }
}

ProcessResult executeCommand(List<String> params) {
  late String flutterExecutable;
  final ProcessResult where = Process.runSync('where', <String>['flutter.bat']);
  if (where.exitCode == 0) {
    final String stdout = where.stdout as String;
    flutterExecutable = stdout.trim();
  }

  final ProcessResult result = Process.runSync(flutterExecutable, params);
  return result;
}
