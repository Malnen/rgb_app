import 'dart:ffi';

import 'package:get_it/get_it.dart';
import 'package:libusb/libusb64.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k_70.dart';
import 'package:rgb_app/devices/corsair_virtuoso/corsair_virtuoso.dart';
import 'package:rgb_app/devices/steel_series_rival_100/steel_series_rival_100.dart';
import 'package:rgb_app/devices/unknown_device.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/utils/libusb_loader.dart';
import 'package:flutter/material.dart' as material;

abstract class DeviceInterface {
  late EffectBloc effectBloc;
  late Pointer<libusb_device_handle> devHandle;
  late DeviceData deviceData;

  bool get isReady => devHandle.address > 0;

  int get offsetX => deviceData.offsetX;

  int get offsetY => deviceData.offsetY;

  DeviceInterface({
    required this.deviceData,
  }) {
    effectBloc = GetIt.instance.get();
  }

  Libusb get libusb => LibusbLoader.getInstance;

  static DeviceInterface fromDeviceData({required final DeviceData deviceData}) {
    final DeviceProductVendor deviceProductVendor = deviceData.deviceProductVendor;
    final String productVendor = deviceProductVendor.productVendor;
    switch (productVendor) {
      case DeviceProductVendor.corsairK70:
        return CorsairK70(
          deviceData: deviceData,
        );
      case DeviceProductVendor.corsairVirtuoso:
        return CorsairVirtuoso(
          deviceData: deviceData,
        );
      case DeviceProductVendor.steelSeriesRival100:
        return SteelSeriesRival100(
          deviceData: deviceData,
        );
      default:
        return UnknownDevice(deviceData: deviceData);
    }
  }

  static Pointer<libusb_device_handle> initDeviceHandler({
    required final DeviceData deviceData,
    required final int interface,
    required final int configuration,
  }) {
    final Libusb libusb = LibusbLoader.getInstance;
    final Pointer<libusb_device_handle> devHandle = libusb.libusb_open_device_with_vid_pid(
      nullptr,
      int.parse('0x${deviceData.deviceProductVendor.vendorId}'),
      int.parse('0x${deviceData.deviceProductVendor.productId}'),
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

  material.Size getSize();
}
