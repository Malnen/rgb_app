import 'dart:ffi';

import 'package:ffi/ffi.dart' show calloc;

extension PointerExtension on Pointer<NativeType> {
  void free() {
    calloc.free(this);
  }
}
