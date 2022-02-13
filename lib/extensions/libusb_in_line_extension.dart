import 'dart:ffi';

import 'package:libusb/libusb64.dart';

extension LibusbInline on Libusb {
  int inlineLibusbGetStringDescriptor(
      Pointer<libusb_device_handle> devHandle,
      int descIndex,
      int langid,
      Pointer<Uint8> data,
      int length,) {
    return libusb_control_transfer(
      devHandle,
      libusb_endpoint_direction.LIBUSB_ENDPOINT_IN,
      libusb_standard_request.LIBUSB_REQUEST_GET_DESCRIPTOR,
      libusb_descriptor_type.LIBUSB_DT_STRING << 8 | descIndex,
      langid,
      data,
      length,
      1000,
    );
  }
}