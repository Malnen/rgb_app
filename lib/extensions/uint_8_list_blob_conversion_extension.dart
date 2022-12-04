import 'dart:ffi';
import 'dart:typed_data';
import 'package:ffi/ffi.dart' show calloc;

extension Uint8ListBlobConversion on Uint8List {
  Pointer<Uint8> allocatePointer() {
    final Pointer<Uint8> blob = calloc<Uint8>(length);
    final Uint8List blobBytes = blob.asTypedList(length);
    blobBytes.setAll(0, this);

    return blob;
  }
}