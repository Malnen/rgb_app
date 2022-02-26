import 'dart:convert';
import 'dart:ffi';

import 'package:libusb/libusb64.dart';
import 'package:rgb_app/utils/libusb_loader.dart';

extension LibusbExtension on Libusb {
  static const int _kMaxSmi64 = (1 << 62) - 1;
  static const int _kMaxSmi32 = (1 << 30) - 1;
  static final int _maxSize = sizeOf<IntPtr>() == 8 ? _kMaxSmi64 : _kMaxSmi32;
  static final Libusb _libusb = LibusbLoader.getInstance;

  String describeError(int error) {
    var array = _libusb.libusb_error_name(error);
    var nativeString = array.cast<Uint8>().asTypedList(_maxSize);
    var strlen = nativeString.indexWhere((char) => char == 0);
    return utf8.decode(array.cast<Uint8>().asTypedList(strlen));
  }
}
