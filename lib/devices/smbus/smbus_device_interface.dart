import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/smbus/models/smbus_transaction_data.dart';
import 'package:rgb_app/models/device_data.dart';

abstract class SMBusDeviceInterface extends DeviceInterface {
  @override
  SMBusDeviceData get deviceData => super.deviceData as SMBusDeviceData;

  SMBusDeviceInterface({required super.deviceData});

  SMBusTransactionData get colorData;
}
