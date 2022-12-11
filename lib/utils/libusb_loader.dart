import 'dart:ffi';

import 'package:libusb/libusb64.dart';
import 'package:rgb_app/utils/library_loader.dart';

class LibusbLoader {
  static late Libusb _instance;

  static Libusb get getInstance => _instance;

  static void initLibusb() {
    final DynamicLibrary library = LibraryLoader.loadLibrary('libusb-1.0');
    _instance = Libusb(library);
    _instance.libusb_init(nullptr);
  }
}
