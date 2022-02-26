import 'package:rgb_app/devices/device.dart';
import 'package:rgb_app/devices/device_interface.dart';

class UnknownDevice extends DeviceInterface {
  UnknownDevice({required Device device}) : super(device: device);

  @override
  void init() {}

  @override
  void sendData() {}

  @override
  void dispose() {}

  @override
  void test() {}
}
