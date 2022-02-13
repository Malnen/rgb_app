import 'dart:ffi';

import 'package:libusb/libusb64.dart';
import 'package:rgb_app/devices/corsair_k_70.dart';
import 'package:rgb_app/devices/steel_series_rival_100.dart';
import 'package:rgb_app/devices/unknown_device.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

import 'device.dart';

abstract class DeviceInterface {
  final Device device;

  late Pointer<libusb_device_handle> devHandle;

  DeviceInterface({required this.device});

  static DeviceInterface fromDevice(Device device) {
    switch (device.deviceProductVendor) {
      case DeviceProductVendor.corsairK70:
        return CorsairK70(device: device);
      case DeviceProductVendor.steelSeriesRival100:
        return SteelSeriesRival100(device: device);
      default:
        return UnknownDevice(device: device);
    }
  }

  void init();

  void sendData();

  void dispose();
}
