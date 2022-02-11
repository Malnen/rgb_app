import 'dart:ffi';
import 'dart:io';
import 'package:libusb/libusb64.dart';

class LibusbLoader {
  static late Libusb _instance;

  static Libusb get getInstance => _instance;

  static void initLibusb(){
    _instance = Libusb(loadLibrary());
  }

  static DynamicLibrary Function() loadLibrary = () {
    if (Platform.isWindows) {
      return DynamicLibrary.open(
          '${Directory.current.path}/libusb-1.0/libusb-1.0.dll');
    }
    if (Platform.isMacOS) {
      return DynamicLibrary.open(
          '${Directory.current.path}/libusb-1.0/libusb-1.0.dylib');
    } else if (Platform.isLinux) {
      return DynamicLibrary.open(
          '${Directory.current.path}/libusb-1.0/libusb-1.0.so');
    }
    throw 'libusb dynamic library not found';
  };
}
