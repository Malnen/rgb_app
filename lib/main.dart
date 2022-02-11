import 'package:rgb_app/libusb_loader/libusb_loader.dart';
import 'package:rgb_app/quick_usb/quick_usb.dart';

void main() {
  LibusbLoader.initLibusb();

  var deviceProductInfo = QuickUsb().getDeviceProductInfo();
  print('deviceProductInfo $deviceProductInfo');
}
