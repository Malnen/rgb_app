import 'dart:ffi';
import 'dart:typed_data';

import 'package:libusb/libusb64.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/extensions/uint_8_list_blob_conversion_extension.dart';

import '../libusb_loader/libusb_loader.dart';
import 'package:ffi/ffi.dart' show calloc;
import 'device.dart';

class CorsairK70 extends DeviceInterface {
  CorsairK70({required Device device}) : super(device: device);

  Libusb get libusb => LibusbLoader.getInstance;

  @override
  void init() {
    libusb.libusb_init(nullptr);
    devHandle = libusb.libusb_open_device_with_vid_pid(
      nullptr,
      int.parse('0x${device.vendorId}'),
      int.parse('0x${device.productId}'),
    );

    libusb.libusb_claim_interface(devHandle, 1);
    libusb.libusb_set_configuration(devHandle, 1);
  }

  void sendData() {
    final Uint8List dataPkt1 = Uint8List.fromList([
      0x07,
      0x28,
      0x01,
      0x03,
      0x01,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00
    ]);

    final Uint8List dataPkt2 = Uint8List.fromList([
      0x07,
      0x28,
      0x02,
      0x03,
      0x01,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00
    ]);
    final Uint8List dataPkt3 = Uint8List.fromList([
      0x07,
      0x28,
      0x03,
      0x03,
      0x01,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00
    ]);

    final Uint8List rPkt1 = Uint8List.fromList([
      0x7F,
      0x01,
      0x3C,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00
    ]);

    final Uint8List rPkt2 = Uint8List.fromList([
      0x7F,
      0x02,
      0x3C,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00
    ]);

    final Uint8List rPkt3 = Uint8List.fromList([
      0x7F,
      0x03,
      0x30,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00
    ]);

    final Uint8List gPkt1 = Uint8List.fromList([
      0x7F,
      0x01,
      0x3C,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00
    ]);

    final Uint8List gPkt2 = Uint8List.fromList([
      0x7F,
      0x02,
      0x3C,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00
    ]);

    final Uint8List gPkt3 = Uint8List.fromList([
      0x7F,
      0x03,
      0x30,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00
    ]);

    final Uint8List bPkt1 = Uint8List.fromList([
      0x7F,
      0x01,
      0x3C,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00
    ]);

    final Uint8List bPkt2 = Uint8List.fromList([
      0x7F,
      0x02,
      0x3C,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00
    ]);

    final Uint8List bPkt3 = Uint8List.fromList([
      0x7F,
      0x03,
      0x30,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0xFF,
      0xFF,
      0xFF,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00,
      0x00
    ]);

    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      rPkt1.allocatePointer(),
      64,
      calloc<Int32>(),
      1000,
    );
    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      rPkt2.allocatePointer(),
      64,
      calloc<Int32>(),
      1000,
    );
    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      rPkt3.allocatePointer(),
      64,
      calloc<Int32>(),
      1000,
    );
    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      dataPkt1.allocatePointer(),
      64,
      calloc<Int32>(),
      1000,
    );

    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      gPkt1.allocatePointer(),
      64,
      calloc<Int32>(),
      1000,
    );
    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      gPkt2.allocatePointer(),
      64,
      calloc<Int32>(),
      1000,
    );
    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      gPkt3.allocatePointer(),
      64,
      calloc<Int32>(),
      1000,
    );
    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      dataPkt2.allocatePointer(),
      64,
      calloc<Int32>(),
      1000,
    );

    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      bPkt1.allocatePointer(),
      64,
      calloc<Int32>(),
      1000,
    );
    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      bPkt2.allocatePointer(),
      64,
      calloc<Int32>(),
      1000,
    );
    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      bPkt3.allocatePointer(),
      64,
      calloc<Int32>(),
      1000,
    );
    libusb.libusb_bulk_transfer(
      devHandle,
      0x02,
      dataPkt3.allocatePointer(),
      64,
      calloc<Int32>(),
      1000,
    );
  }

  @override
  void dispose() {
    libusb.libusb_close(devHandle);
  }
}
