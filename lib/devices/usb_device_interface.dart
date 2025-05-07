import 'package:flutter/cupertino.dart';
import 'package:rgb_app/devices/device_interface.dart';

abstract class UsbDeviceInterface extends DeviceInterface {
  late String guid;

  int get interface;

  int get configuration;

  UsbDeviceInterface({required super.deviceData});

  @protected
  Map<String, Object> getDataToSend();

  @protected
  List<List<int>> getPackets();

  Map<String, Object?> getPayload() => <String, Object?>{
        'packets': getPackets(),
        'guid': guid,
        ...getDataToSend(),
      };
}
