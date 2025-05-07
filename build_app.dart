import 'dart:io';

import 'package:path/path.dart' as path;

void main() async {
  copyAssets();
  await generateFiles();
  await runFlutterBuildWindows();
}

void copyAssets() {
  print('Copying rgbAppService');
  final String sourceDir = 'C:\\Users\\malne\\RiderProjects\\RgbAppService\\Output';
  final String destinationDir = 'assets/rgbAppService';
  Directory(destinationDir).createSync(recursive: true);
  copyDirectory(Directory(sourceDir), Directory(destinationDir));
  print('Copied');
}

Future<void> generateFiles() async {
  print('Generating files...');
  final ProcessResult result = await executeCommand(<String>[
    'pub',
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
    'models:generated',
  ]);
  if (result.exitCode == 0) {
    print('Files generated');
  } else {
    print('Error: Files generation failed. Exit code: ${result.exitCode}');
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

Future<void> runFlutterBuildWindows() async {
  print('Running flutter build...');
  await executeCommand(<String>['clean']);
  final ProcessResult result = await executeCommand(<String>['build', 'windows']);
  if (result.exitCode == 0) {
    print('Done');
  } else {
    print('Error, exit code: ${result.exitCode}');
    print('Stderr: ${result.stderr}');
  }
}

Future<ProcessResult> executeCommand(List<String> params) async {
  final Directory fvmDirectory = Directory('./.fvm');
  final bool useFvm = await fvmDirectory.exists();
  late Process process;
  if (useFvm) {
    process = await Process.start('fvm', <String>['flutter', ...params]);
  } else {
    process = await runCommandWithGlobalFlutter(params);
  }

  process.stdout.transform(SystemEncoding().decoder).listen((String data) => print(data.trim()));
  process.stderr.transform(SystemEncoding().decoder).listen((String data) => print(data.trim()));
  final int exitCode = await process.exitCode;

  return ProcessResult(process.pid, exitCode, '', '');
}

Future<Process> runCommandWithGlobalFlutter(List<String> params) {
  late String flutterExecutable;
  final ProcessResult where = Process.runSync('where', <String>['flutter.bat']);
  if (where.exitCode == 0) {
    final String stdout = where.stdout as String;
    flutterExecutable = stdout.trim();
  }

  return Process.start(flutterExecutable, params);
}
