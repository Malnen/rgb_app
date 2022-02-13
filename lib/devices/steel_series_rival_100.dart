import 'dart:ffi';
import 'dart:typed_data';

import 'package:libusb/libusb64.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/extensions/uint_8_list_blob_conversion_extension.dart';

import '../libusb_loader/libusb_loader.dart';
import 'device.dart';

class SteelSeriesRival100 implements DeviceInterface {
  final Device device;

  late Pointer<libusb_device_handle> devHandle;

  SteelSeriesRival100({required this.device});

  Libusb get libusb => LibusbLoader.getInstance;

  void init() {
    libusb.libusb_init(nullptr);
    devHandle = libusb.libusb_open_device_with_vid_pid(
      nullptr,
      int.parse('0x${device.vendorId}'),
      int.parse('0x${device.productId}'),
    );

    libusb.libusb_claim_interface(devHandle, 0);
    libusb.libusb_set_configuration(devHandle, 1);
  }

  void sendData() {
    final Uint8List data = Uint8List.fromList([
      0x05,
      0x00,
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
      0x00
    ]);
    libusb.libusb_control_transfer(
      devHandle,
      0x21,
      0x09,
      0x200,
      0x00,
      data.allocatePointer(),
      32,
      10,
    );
  }
}
