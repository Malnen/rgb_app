import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/utils/assets_loader.dart';
import 'package:rgb_app/utils/dependency_initializer.dart';
import 'package:rgb_app/utils/libusb_loader.dart';
import 'package:rgb_app/utils/usb_device_change/usb_device_change_detector.dart';
import 'package:rgb_app/widgets/main_frame/main_frame.dart';
import 'package:system_tray/system_tray.dart';

void main() {
  _run();
}

Future<void> _run() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kDebugMode) {
    await _initSystemTray();
  }

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  LibusbLoader.initLibusb();
  DependencyInitializer.init();

  _initUsbDetector();
  runApp(const MainFrame());
}

Future<void> _initSystemTray() async {
  final AppWindow appWindow = AppWindow();
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
        onClicked: (MenuItemBase menuItem) => appWindow.show(),
      ),
      MenuItemLabel(
        label: 'Hide',
        onClicked: (MenuItemBase menuItem) => appWindow.hide(),
      ),
      MenuItemLabel(
        label: 'Exit',
        onClicked: (MenuItemBase menuItem) => appWindow.close(),
      ),
    ],
  );
  await systemTray.setContextMenu(menu);
  systemTray.registerSystemTrayEventHandler((String eventName) {
    switch (eventName) {
      case kSystemTrayEventClick:
        appWindow.show();
        break;
      case kSystemTrayEventRightClick:
        systemTray.popUpContextMenu();
        break;
    }
  });
  if (!kDebugMode) {
    await appWindow.hide();
  }
}

void _initUsbDetector() {
  final UsbDeviceChangeDetector detector = UsbDeviceChangeDetector(() {
    final DevicesBloc devicesBloc = GetIt.instance.get();
    final CheckDevicesConnectionStateEvent event = CheckDevicesConnectionStateEvent();
    devicesBloc.add(event);
  });
  detector.init();
  GetIt.instance.registerSingleton(detector);
}
