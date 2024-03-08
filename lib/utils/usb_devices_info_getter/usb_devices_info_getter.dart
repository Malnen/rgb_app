import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/device_product_vendor.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service_listener.dart';
import 'package:rgb_app/utils/usb_devices_info_getter/enums/connected_usb_device_command.dart';
import 'package:rgb_app/utils/usb_devices_info_getter/enums/connected_usb_device_response_type.dart';
import 'package:rxdart/rxdart.dart';

class UsbDeviceInfoGetter with RgbAppServiceListener<ConnectedUsbDeviceCommand, ConnectedUsbDeviceResponseType> {
  late BehaviorSubject<List<DeviceData>> deviceData;

  @override
  String get channelName => 'connectedUsbDevicesInfo';

  @override
  Iterable<ConnectedUsbDeviceResponseType> get responseTypes => ConnectedUsbDeviceResponseType.values;

  @override
  void Function(ConnectedUsbDeviceResponseType, Map<String, Object>) get processResponse => _channelListener;

  @override
  Future<void> init() async {
    deviceData = BehaviorSubject<List<DeviceData>>();
    await super.init();
  }

  @override
  void dispose() {
    deviceData.close();
    super.dispose();
  }

  Future<List<DeviceData>> getDeviceProductInfo() async {
    sendCommand(ConnectedUsbDeviceCommand.getUsbDevicesInfo);
    final List<DeviceData> data = await deviceData.stream.first;
    await deviceData.close();
    deviceData = BehaviorSubject<List<DeviceData>>();

    return data;
  }

  void _channelListener(ConnectedUsbDeviceResponseType responseType, Map<String, Object> parsedData) {
    switch (responseType) {
      case ConnectedUsbDeviceResponseType.usbDeviceInfo:
        _onUsbDeviceInfo(parsedData);
        break;
    }
  }

  void _onUsbDeviceInfo(Map<String, Object> parsedData) {
    final List<DeviceData> devicesData = <DeviceData>[];
    final List<Object?> rawDevices = List<Object>.from(parsedData['devices'] as List<Object?>);
    final List<Map<String, Object?>> devices = List<Map<String, Object?>>.from(rawDevices);
    for (final Map<String, Object?> device in devices) {
      final DeviceProductVendor deviceProductVendor = DeviceProductVendor.getByProductVendor(device);
      final DeviceData data = DeviceData(deviceProductVendor: deviceProductVendor);
      devicesData.add(data);
    }

    deviceData.sink.add(devicesData.where((DeviceData device) => device.isKnownDevice).toList());
  }
}
