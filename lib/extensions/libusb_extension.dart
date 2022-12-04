import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:libusb/libusb64.dart';
import 'package:rgb_app/utils/libusb_loader.dart';

extension LibusbExtension on Libusb {
  static const int _kMaxSmi64 = (1 << 62) - 1;
  static const int _kMaxSmi32 = (1 << 30) - 1;
  static final int _maxSize = sizeOf<IntPtr>() == 8 ? _kMaxSmi64 : _kMaxSmi32;
  static final Libusb _libusb = LibusbLoader.getInstance;

  String describeError(final int error) {
    final Pointer<Int8> array = _libusb.libusb_error_name(error);
    final Uint8List nativeString = array.cast<Uint8>().asTypedList(_maxSize);
    final int length = nativeString.indexWhere((final int char) => char == 0);
    final Uint8List typedList = array.cast<Uint8>().asTypedList(length);

    return utf8.decode(typedList);
  }
}
