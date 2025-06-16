import 'package:rgb_app/devices/sub_device_interface.dart';
import 'package:rgb_app/devices/usb_device_interface.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/property.dart';

abstract class LightningControllerInterface extends UsbDeviceInterface {
  final List<SubDeviceInterface> subDevices;

  LightningControllerInterface({required super.deviceData, required super.usbDeviceDataSender})
      : subDevices = <SubDeviceInterface>[];

  @override
  LightningControllerDeviceData get deviceData => super.deviceData as LightningControllerDeviceData;

  @override
  List<Property<Object>> get properties => <Property<Object>>[];
}
