import 'dart:async';

import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/usb_device_interface.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/device_product_vendor.dart';
import 'package:rgb_app/utils/frame_throttler.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service_listener.dart';
import 'package:rgb_app/utils/usb_device_data_sender/enums/usb_device_data_sender_command.dart';
import 'package:rgb_app/utils/usb_device_data_sender/enums/usb_device_data_sender_response_type.dart';

class UsbDeviceDataSender with RgbAppServiceListener<UsbDeviceDataSenderCommand, UsbDeviceDataSenderResponseType>, FrameThrottler {
  final Map<String, DeviceInterface> pendingDevices;

  UsbDeviceDataSender() : pendingDevices = <String, DeviceInterface>{};

  @override
  String get channelName => 'usbDeviceData';

  @override
  Iterable<UsbDeviceDataSenderResponseType> get responseTypes => UsbDeviceDataSenderResponseType.values;

  @override
  void Function(UsbDeviceDataSenderResponseType, Map<String, Object>) get processResponse => _responseListener;

  Future<Map<String, Object>> openDevice(UsbDeviceInterface deviceInterface) {
    final UsbDeviceData deviceData = deviceInterface.deviceData;
    final DeviceProductVendor deviceProductVendor = deviceData.deviceProductVendor;
    return _sendDeviceCommand(
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

  Future<void> sendData(List<Map<String, Object?>> data, {bool throttled = true}) => throttled
      ? runThrottled(
          () => sendCommand(
            UsbDeviceDataSenderCommand.sendData,
            data: <String, Object?>{
              'data': data,
            },
          ),
        )
      : sendCommand(
          UsbDeviceDataSenderCommand.sendData,
          data: <String, Object?>{
            'data': data,
          },
        );

  Future<List<int>> readData({
    required String guid,
    required int endpoint,
    int length = 512,
    int timeout = 1000,
  }) async {
    final Map<String, Object> response = await sendCommand(
      UsbDeviceDataSenderCommand.interruptRead,
      data: <String, Object>{
        'data': <String, Object>{
          'guid': guid,
          'endpoint': endpoint,
          'length': length,
          'timeout': timeout,
        },
      },
    );

    final Object? rawData = response['data'];
    if (rawData is List<dynamic>) {
      return rawData.map((Object? value) => value as int).toList();
    } else {
      throw Exception('Invalid data format from USB interrupt read');
    }
  }

  void closeDevice(UsbDeviceInterface deviceInterface) {
    deviceInterface.isOpen.sink.add(false);
    _sendDeviceCommand(
      deviceInterface,
      UsbDeviceDataSenderCommand.closeDevice,
      data: <String, Object>{
        'guid': deviceInterface.guid,
      },
    );
  }

  Future<Map<String, Object>> _sendDeviceCommand(
    DeviceInterface deviceInterface,
    UsbDeviceDataSenderCommand command, {
    Map<String, Object?>? data,
  }) {
    final UsbDeviceData deviceData = deviceInterface.deviceData as UsbDeviceData;
    final DeviceProductVendor deviceProductVendor = deviceData.deviceProductVendor;
    pendingDevices[deviceProductVendor.productVendor] = deviceInterface;
    return sendCommand(
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
      case UsbDeviceDataSenderResponseType.dataRead:
        break;
    }
  }

  void _onDeviceOpened(Map<String, Object> data) {
    final DeviceProductVendor deviceProductVendor = DeviceProductVendor.getByProductVendor(data);
    final String productVendor = deviceProductVendor.productVendor;
    final UsbDeviceInterface? deviceInterface = pendingDevices[productVendor] as UsbDeviceInterface?;
    pendingDevices.remove(productVendor);
    deviceInterface?.isOpen.sink.add(true);
    deviceInterface?.guid = data['guid'] as String;
  }
}
