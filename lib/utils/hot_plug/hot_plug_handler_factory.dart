import 'dart:io';
import 'package:rgb_app/utils/hot_plug/windows_usb_hot_plug_handler.dart';

class HotPlugHandlerFactory {
  static void createHandlers() {
    if (Platform.isWindows) {
      WindowsUsbHotPlugHandler.init();
      WindowsUsbHotPlugHandler.tryRegisterUsbConnectedCallback();
    } else {
      print('Unsupported platform');
    }
  }
}
