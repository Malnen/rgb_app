import 'dart:ffi';

import 'package:libusb/libusb64.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/devices/steel_series_rival_100/steel_series_rival_100.dart';
import 'package:rgb_app/devices/unknown_device.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

import '../utils/libusb_loader.dart';
import 'corsair_k_70/corsair_k_70.dart';
import 'device.dart';

abstract class DeviceInterface {
  final Device device;

  late Pointer<libusb_device_handle> devHandle;

  DeviceInterface({
    required this.device,
  });

  Libusb get libusb => LibusbLoader.getInstance;

  static DeviceInterface fromDevice({
    required Device device,
    KeyBloc? keyBloc,
  }) {
    switch (device.deviceProductVendor.productVendor) {
      case DeviceProductVendor.corsairK70:
        return CorsairK70(
          device: device,
          keyBloc: keyBloc,
        );
      case DeviceProductVendor.steelSeriesRival100:
        return SteelSeriesRival100(device: device);
      default:
        return UnknownDevice(device: device);
    }
  }

  void init();

  void sendData();

  void dispose() {
    libusb.libusb_close(devHandle);
  }

  void test();

  void blink();
}
