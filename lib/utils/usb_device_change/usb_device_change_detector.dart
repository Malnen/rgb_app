import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service.dart';
import 'package:rgb_app/utils/usb_device_change/enums/usb_device_change_response_type.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class UsbDeviceChangeDetector {
  final VoidCallback usbDeviceChangedCallback;

  final RgbAppService _service;

  late final WebSocketChannel _channel;

  UsbDeviceChangeDetector(this.usbDeviceChangedCallback) : _service = GetIt.instance.get();

  void init() async {
    await _createWebSocketConnection();
  }

  void dispose() {
    _channel.sink.close();
  }

  Future<void> _createWebSocketConnection() async {
    _channel = await _service.connect('usbDeviceChange', _channelListener);
  }

  void _channelListener(Object? data) {
    final String json = data.toString();
    final Map<String, Object> parsedData = Map<String, Object>.from(jsonDecode(json) as Map<String, Object?>);
    final UsbDeviceChangeResponseType responseType = UsbDeviceChangeResponseType.values.byName(
      parsedData['responseType'] as String,
    );
    switch (responseType) {
      case UsbDeviceChangeResponseType.deviceChanged:
        usbDeviceChangedCallback();
        break;
    }
  }
}
