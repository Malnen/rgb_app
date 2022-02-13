import 'package:rgb_app/devices/corsair_k_70.dart';
import 'package:rgb_app/devices/steel_series_rival_100.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:rgb_app/libusb_loader/libusb_loader.dart';
import 'package:rgb_app/quick_usb/quick_usb.dart';

import 'devices/device.dart';

void main() {
  LibusbLoader.initLibusb();

  final List<Device> deviceProductInfo = QuickUsb().getDeviceProductInfo();

  final Device mouse = deviceProductInfo.firstWhere((Device device) =>
      device.deviceProductVendor == DeviceProductVendor.steelSeriesRival100);
  final SteelSeriesRival100 steelSeriesRival100 =
      SteelSeriesRival100(device: mouse);
  steelSeriesRival100.init();
  steelSeriesRival100.sendData();

  final Device keyboard = deviceProductInfo.firstWhere((Device device) =>
      device.deviceProductVendor == DeviceProductVendor.corsairK70);
  final CorsairK70 corsairK70 = CorsairK70(device: keyboard);
  corsairK70.init();
  corsairK70.sendData();
}
