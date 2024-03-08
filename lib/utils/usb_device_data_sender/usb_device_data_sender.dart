import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/device_product_vendor.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service_listener.dart';
import 'package:rgb_app/utils/usb_device_data_sender/enums/usb_device_data_sender_command.dart';
import 'package:rgb_app/utils/usb_device_data_sender/enums/usb_device_data_sender_response_type.dart';

class UsbDeviceDataSender with RgbAppServiceListener<UsbDeviceDataSenderCommand, UsbDeviceDataSenderResponseType> {
  final Map<String, DeviceInterface> pendingDevices;

  UsbDeviceDataSender() : pendingDevices = <String, DeviceInterface>{};

  @override
  String get channelName => 'usbDeviceData';

  @override
  Iterable<UsbDeviceDataSenderResponseType> get responseTypes => UsbDeviceDataSenderResponseType.values;

  @override
  void Function(UsbDeviceDataSenderResponseType, Map<String, Object>) get processResponse => _responseListener;

  void openDevice(DeviceInterface deviceInterface) {
    final DeviceData deviceData = deviceInterface.deviceData;
    final DeviceProductVendor deviceProductVendor = deviceData.deviceProductVendor;
    _sendDeviceCommand(
      deviceInterface,
      UsbDeviceDataSenderCommand.openDevice,
      data: <String, Object>{
        'interface': deviceInterface.interface,
        'configuration': deviceInterface.configuration,
        'productId': deviceProductVendor.productId,
        'vendorId': deviceProductVendor.vendorId,
      },
    );
  }

  void sendData(DeviceInterface deviceInterface) {
    _sendDeviceCommand(
      deviceInterface,
      UsbDeviceDataSenderCommand.sendData,
      data: <String, Object>{
        'packets': deviceInterface.getPackets(),
        'guid': deviceInterface.guid,
        ...deviceInterface.getDataToSend(),
      },
    );
  }

  void closeDevice(DeviceInterface deviceInterface) {
    deviceInterface.isOpen.sink.add(false);
    _sendDeviceCommand(
      deviceInterface,
      UsbDeviceDataSenderCommand.closeDevice,
      data: <String, Object>{
        'guid': deviceInterface.guid,
      },
    );
  }

  void _sendDeviceCommand(
    DeviceInterface deviceInterface,
    UsbDeviceDataSenderCommand command, {
    Map<String, Object>? data,
  }) {
    final DeviceData deviceData = deviceInterface.deviceData;
    final DeviceProductVendor deviceProductVendor = deviceData.deviceProductVendor;
    pendingDevices[deviceProductVendor.productVendor] = deviceInterface;
    sendCommand(
      command,
      data: <String, Object?>{
        'data': data,
      },
    );
  }

  void _responseListener(UsbDeviceDataSenderResponseType responseType, Map<String, Object> data) {
    switch (responseType) {
      case UsbDeviceDataSenderResponseType.deviceOpened:
        _onDeviceOpened(data);
        break;
      case UsbDeviceDataSenderResponseType.dataSent:
        break;
      case UsbDeviceDataSenderResponseType.deviceClosed:
        break;
    }
  }

  void _onDeviceOpened(Map<String, Object> data) {
    final DeviceProductVendor deviceProductVendor = DeviceProductVendor.getByProductVendor(data);
    final String productVendor = deviceProductVendor.productVendor;
    final DeviceInterface? deviceInterface = pendingDevices[productVendor];
    pendingDevices.remove(productVendor);
    deviceInterface?.isOpen.sink.add(true);
    deviceInterface?.guid = data['guid'] as String;
  }
}
