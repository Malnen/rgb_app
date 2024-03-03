import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/utils/rgb_app_service/models/rgb_app_service_request.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

mixin RgbAppServiceListener<Command extends Enum, ResponseType extends Enum> {
  late final RgbAppService _service;

  @protected
  String get channelName;

  @protected
  Iterable<ResponseType> get responseTypes;

  @protected
  void Function(ResponseType, Map<String, Object>) get processResponse;

  late final WebSocketChannel _channel;

  Future<void> init() async {
    _service = GetIt.instance.get();
    await _createWebSocketConnection();
  }

  void dispose() {
    _channel.sink.close();
  }

  @protected
  void sendCommand(Command command, {Map<String, Object?>? data}) {
    final RgbAppServiceRequest rgbAppServiceRequest = RgbAppServiceRequest(command: command.name, data: data);
    _service.sendCommand(rgbAppServiceRequest, _channel);
  }

  Future<void> _createWebSocketConnection() async {
    _channel = await _service.connect(channelName, _channelListener);
  }

  void _channelListener(Object? data) {
    final String json = data.toString();
    final Map<String, Object> parsedData = Map<String, Object>.from(jsonDecode(json) as Map<String, Object?>);
    final ResponseType responseType = responseTypes.byName(parsedData['responseType'] as String);
    processResponse(responseType, parsedData);
  }
}
