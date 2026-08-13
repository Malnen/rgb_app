import 'package:rgb_app/devices/device_interface.dart';

abstract class DeviceDataSender {
  Future<void> init();

  Future<Map<String, Object>> openDevice(DeviceInterface deviceInterface);

  Future<void> sendData(List<Map<String, Object?>> data, {bool throttled = true});

  Future<List<int>> readData({
    required String guid,
    required int endpoint,
    int length = 512,
    int timeout = 1000,
  });

  void closeDevice(DeviceInterface deviceInterface);
}
