import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rgb_app/utils/assets_loader.dart';
import 'package:rgb_app/utils/dependency_initializer.dart';
import 'package:rgb_app/widgets/main_frame/main_frame.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_single_instance/windows_single_instance.dart';

void main() {
  _run();
}

Future<void> _run() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await WindowsSingleInstance.ensureSingleInstance(
    <String>[],
    'rgb_app',
    bringWindowToFront: true,
  );
  final WindowOptions windowOptions = WindowOptions(
    size: Size(1200, 600),
    backgroundColor: Colors.transparent,
  );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  await DependencyInitializer.init();
  runApp(const MainFrame());
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await _initSystemTray();
    if (kDebugMode) {
      await windowManager.show();
    }
  });
}

Future<void> _initSystemTray() async {
  final SystemTray systemTray = SystemTray();
  final Menu menu = Menu();
  await systemTray.initSystemTray(
    title: 'system tray',
    iconPath: AssetsLoader.getAssetPath(
      name: 'app_icon.ico',
      withAbsolutePath: true,
    ),
  );
  await menu.buildFrom(
    <MenuItemLabel>[
      MenuItemLabel(
        label: 'Show',
        onClicked: (MenuItemBase menuItem) => windowManager.show(),
      ),
      MenuItemLabel(
        label: 'Hide',
        onClicked: (MenuItemBase menuItem) => windowManager.hide(),
      ),
      MenuItemLabel(
        label: 'Exit',
        onClicked: (MenuItemBase menuItem) async {
          await windowManager.setPreventClose(false);
          await windowManager.close();
        },
      ),
    ],
  );
  await systemTray.setContextMenu(menu);
  systemTray.registerSystemTrayEventHandler(
    (String eventName) => switch (eventName) {
      kSystemTrayEventClick => windowManager.show(),
      kSystemTrayEventRightClick => systemTray.popUpContextMenu(),
      _ => throw UnimplementedError(),
    },
  );
}
