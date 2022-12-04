import 'dart:ffi';

import 'package:get_it/get_it.dart';
import 'package:libusb/libusb64.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k_70.dart';
import 'package:rgb_app/devices/corsair_virtuoso/corsair_virtuoso.dart';
import 'package:rgb_app/devices/device.dart';
import 'package:rgb_app/devices/steel_series_rival_100/steel_series_rival_100.dart';
import 'package:rgb_app/devices/unknown_device.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:rgb_app/utils/libusb_loader.dart';

abstract class DeviceInterface {
  final Device device;

  late EffectBloc effectBloc;
  late Pointer<libusb_device_handle> devHandle;

  bool get isReady => devHandle.address > 0;

  int offsetX = 0;
  int offsetY = 0;

  DeviceInterface({required this.device}) {
    effectBloc = GetIt.instance.get();
  }

  Libusb get libusb => LibusbLoader.getInstance;

  static DeviceInterface fromDevice({required final Device device}) {
    final DeviceProductVendor deviceProductVendor = device.deviceProductVendor;
    final String productVendor = deviceProductVendor.productVendor;
    switch (productVendor) {
      case DeviceProductVendor.corsairK70:
        return CorsairK70(device: device);
      case DeviceProductVendor.corsairVirtuoso:
        return CorsairVirtuoso(device: device);
      case DeviceProductVendor.steelSeriesRival100:
        return SteelSeriesRival100(device: device);
      default:
        return UnknownDevice(device: device);
    }
  }

  static Pointer<libusb_device_handle> initDeviceHandler({
    required final Device device,
    required final int interface,
    required final int configuration,
  }) {
    final Libusb libusb = LibusbLoader.getInstance;
    final Pointer<libusb_device_handle> devHandle = libusb.libusb_open_device_with_vid_pid(
      nullptr,
      int.parse('0x${device.deviceProductVendor.vendorId}'),
      int.parse('0x${device.deviceProductVendor.productId}'),
    );
    if (devHandle.address > 0) {
      libusb.libusb_claim_interface(devHandle, interface);
      libusb.libusb_set_configuration(devHandle, configuration);
    }

    return devHandle;
  }

  void init() {
    try {
      initDevHandle();
    } catch (_) {
      print('Failed to init devHandle $runtimeType');
    }
  }

  void sendData();

  void dispose() {
    if (isReady) {
      libusb.libusb_close(devHandle);
    }
  }

  void test();

  void blink();

  void update() {
    if (isReady) {
      sendData();
    }
  }

  void initDevHandle();
}
