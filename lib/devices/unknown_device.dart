import 'package:rgb_app/devices/device_interface.dart';
import 'package:vector_math/vector_math.dart';

class UnknownDevice extends DeviceInterface {
  UnknownDevice({required super.deviceData});

  @override
  void test() {}

  @override
  void blink() {}

  @override
  void update() {}

  @override
  Vector3 getSize() => Vector3(0, 0, 0);
}
