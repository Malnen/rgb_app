import 'package:flutter/material.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service_listener.dart';
import 'package:rgb_app/utils/usb_device_change/enums/usb_device_change_response_type.dart';

class UsbDeviceChangeDetector with RgbAppServiceListener<UsbDeviceChangeResponseType, Enum> {
  final VoidCallback usbDeviceChangedCallback;

  UsbDeviceChangeDetector(this.usbDeviceChangedCallback);

  @override
  String get channelName => 'usbDeviceChange';

  @override
  Iterable<UsbDeviceChangeResponseType> get responseTypes => UsbDeviceChangeResponseType.values;

  @override
  void Function(UsbDeviceChangeResponseType, Map<String, Object>) get processResponse =>
      (UsbDeviceChangeResponseType responseType, _) => _responseListener(responseType);

  void _responseListener(UsbDeviceChangeResponseType responseType) {
    switch (responseType) {
      case UsbDeviceChangeResponseType.deviceChanged:
        usbDeviceChangedCallback();
        break;
    }
  }
}
