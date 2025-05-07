import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/utils/rgb_app_service/models/rgb_app_service_request.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

mixin RgbAppServiceListener<Command extends Enum, ResponseType extends Enum> {
  late final RgbAppService _service;

  final Map<String, Completer<Map<String, Object>>> _pendingRequests = <String, Completer<Map<String, Object>>>{};

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
  Future<Map<String, Object>> sendCommand(Command command, {Map<String, Object?>? data}) async {
    final String guid = _generateGuid();
    data ??= <String, Object?>{};
    data['commandGuid'] = guid;
    final Completer<Map<String, Object>> completer = Completer<Map<String, Object>>();
    _pendingRequests[guid] = completer;
    final RgbAppServiceRequest rgbAppServiceRequest = RgbAppServiceRequest(command: command.name, data: data);
    _service.sendCommand(rgbAppServiceRequest, _channel);
    try {
      return await completer.future;
    } catch (_) {
    } finally {
      _pendingRequests.remove(guid);
    }

    return <String, Object>{};
  }

  Future<void> _createWebSocketConnection() async {
    _channel = await _service.connect(channelName, _channelListener);
  }

  void _channelListener(Object? data) {
    final String json = data.toString();
    final Map<String, Object> parsedData = Map<String, Object>.from(jsonDecode(json) as Map<String, Object?>);
    final ResponseType responseType = responseTypes.byName(parsedData['responseType'] as String);
    final String? guid = parsedData['commandGuid'] as String?;
    if (_pendingRequests.containsKey(guid)) {
      _pendingRequests[guid]!.complete(parsedData);
      _pendingRequests.remove(guid);
    }

    processResponse(responseType, parsedData);
  }

  String _generateGuid() {
    final Random rand = Random();
    final String guid = List<String>.generate(16, (_) => rand.nextInt(256).toRadixString(16).padLeft(2, '0')).join();

    return guid.toUpperCase();
  }
}
