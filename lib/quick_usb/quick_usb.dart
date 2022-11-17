import 'dart:ffi';

import 'package:ffi/ffi.dart' show calloc;
import 'package:libusb/libusb64.dart';
import 'package:rgb_app/devices/device.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:rgb_app/extensions/libusb_extension.dart';
import 'package:rgb_app/extensions/libusb_in_line_extension.dart';
import 'package:rgb_app/utils/libusb_loader.dart';

class QuickUsb {
  final Libusb _libusb = LibusbLoader.getInstance;

  List<Device> getDeviceProductInfo() {
    final int init = _libusb.libusb_init(nullptr);
    if (init != libusb_error.LIBUSB_SUCCESS) {
      throw StateError('init error: ${_libusb.describeError(init)}');
    }

    final Pointer<Pointer<Pointer<libusb_device>>> deviceListPtr = calloc<Pointer<Pointer<libusb_device>>>();

    return _processDevices(deviceListPtr);
  }

  List<Device> _processDevices(
      Pointer<Pointer<Pointer<libusb_device>>> deviceListPtr) {
    try {
      final int count = _getDeviceList(deviceListPtr);
      if (count < 0) {
        return <Device>[];
      }

      return _tryMapDevices(deviceListPtr);
    } finally {
      calloc.free(deviceListPtr);
      _libusb.libusb_exit(nullptr);
    }
  }

  int _getDeviceList(Pointer<Pointer<Pointer<libusb_device>>> deviceListPtr) {
    return _libusb.libusb_get_device_list(nullptr, deviceListPtr);
  }

  List<Device> _tryMapDevices(
      Pointer<Pointer<Pointer<libusb_device>>> deviceListPtr) {
    try {
      return _iterateDeviceProduct(deviceListPtr.value).toList();
    } finally {
      _libusb.libusb_free_device_list(deviceListPtr.value, 1);
    }
  }

  Iterable<Device> _iterateDeviceProduct(
      Pointer<Pointer<libusb_device>> deviceList) sync* {
    final Pointer<libusb_device_descriptor> descPtr = calloc<libusb_device_descriptor>();
    final Pointer<Pointer<libusb_device_handle>> devHandlePtr = calloc<Pointer<libusb_device_handle>>();
    const int strDescLength = 42;
    final Pointer<Uint8> strDescPtr = calloc<Uint8>(strDescLength);

    for (int i = 0; deviceList[i] != nullptr; i++) {
      final Device deviceProduct = _getDeviceProduct(
        deviceList[i],
        descPtr,
        devHandlePtr,
        strDescPtr,
        strDescLength,
      );
      yield deviceProduct;
    }

    calloc.free(descPtr);
    // calloc.free(devHandlePtr);
    calloc.free(strDescPtr);
  }

  Device _getDeviceProduct(
    Pointer<libusb_device> dev,
    Pointer<libusb_device_descriptor> descPtr,
    Pointer<Pointer<libusb_device_handle>> devHandlePtr,
    Pointer<Uint8> strDescPtr,
    int strDescLength,
  ) {
    final int devDesc = _libusb.libusb_get_device_descriptor(dev, descPtr);
    if (devDesc != libusb_error.LIBUSB_SUCCESS) {
      print('devDesc error: ${_libusb.describeError(devDesc)}');
      return Device.empty();
    }

    final String idVendor = descPtr.ref.idVendor.toRadixString(16).padLeft(4, '0');
    final String idProduct = descPtr.ref.idProduct.toRadixString(16).padLeft(4, '0');
    final String idDevice = '$idVendor:$idProduct';

    if (descPtr.ref.iProduct == 0) {
      print('$idDevice iProduct empty');
      return Device.empty();
    }

    final int open = _libusb.libusb_open(dev, devHandlePtr);
    if (open != libusb_error.LIBUSB_SUCCESS) {
      print('$idDevice open error: ${_libusb.describeError(open)}');
      return Device.empty();
    }
    final Pointer<libusb_device_handle> devHandle = devHandlePtr.value;

    try {
      final int langDesc = _libusb.inlineLibusbGetStringDescriptor(
          devHandle, 0, 0, strDescPtr, strDescLength);
      if (langDesc < 0) {
        print('$idDevice langDesc error: ${_libusb.describeError(langDesc)}');
        return Device.empty();
      }
      final DeviceProductVendor deviceType =
          DeviceProductVendor.getType(idDevice);
      return Device.create(
        deviceProductVendor: deviceType,
        productId: idProduct,
        vendorId: idVendor,
      );
    } finally {
      _libusb.libusb_close(devHandle);
    }
  }
}
