import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rgb_app/utils/dependency_initializer.dart';
import 'package:rgb_app/utils/libusb_loader.dart';
import 'package:rgb_app/widgets/main_frame/main_frame.dart';

void main() {
  _run();
}

Future<void> _run() async {
  WidgetsFlutterBinding.ensureInitialized();
  final HydratedStorage storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  HydratedBlocOverrides.runZoned(
    () {
      LibusbLoader.initLibusb();
      DependencyInitializer.init();
      runApp(const MainFrame());
    },
    storage: storage,
  );
}
