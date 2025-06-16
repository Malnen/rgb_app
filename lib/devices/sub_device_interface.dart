import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/sub_component.dart';
import 'package:vector_math/vector_math.dart';

class SubDeviceInterface extends DeviceInterface {
  final SubComponent subComponent;
  final DeviceInterface parent;

  SubDeviceInterface({required this.subComponent, required this.parent, required super.deviceData});

  @override
  SubDeviceData get deviceData => super.deviceData as SubDeviceData;

  @override
  void blink() {}

  @override
  Vector3 getSize() => subComponent.size;

  @override
  void test() {}
}
