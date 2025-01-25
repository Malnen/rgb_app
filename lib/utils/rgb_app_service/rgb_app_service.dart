import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rgb_app/classes/fixed_size_list.dart';
import 'package:rgb_app/utils/assets_loader.dart';
import 'package:rgb_app/utils/rgb_app_service/models/rgb_app_service_request.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RgbAppService {
  static const String _portKey = '_PORT_';

  final FixedSizeList<String> _logs = FixedSizeList<String>();

  bool _portInitialized = false;

  late ValueNotifier<String> logs;
  late Process _process;
  late StreamSubscription<List<int>> _getPortSubscription;
  late String _port;

  Future<void> init() async {
    logs = ValueNotifier<String>('');
    final String executablePath = AssetsLoader.getAssetPath(
      name: 'rgbAppService/RgbAppService.exe',
      withAbsolutePath: true,
    );
    _process = await Process.start(executablePath, <String>[]);
    final Stream<List<int>> stdout = _process.stdout.asBroadcastStream();
    stdout.listen(_decode);
    _getPortSubscription = stdout.listen(_getPort);
    _process.stderr.listen(_decode);
    while (!_portInitialized) {
      await Future<void>.delayed(Duration(seconds: 1));
    }
  }

  Future<WebSocketChannel> connect(String channel, void Function(Object?) callback) async {
    final Uri uri = Uri.parse('ws://localhost:$_port/$channel');
    final WebSocketChannel webSocketChannel = WebSocketChannel.connect(uri);
    webSocketChannel.stream.listen(callback, onError: print);
    await Future<void>.delayed(Duration(seconds: 1));

    return webSocketChannel;
  }

  void sendCommand(RgbAppServiceRequest request, WebSocketChannel channel) {
    final Map<String, Object?> json = request.toJson();
    final String body = jsonEncode(json);

    return channel.sink.add(body);
  }

  void dispose() {
    _process.kill();
  }

  void _decode(List<int> data) {
    final String output = String.fromCharCodes(data);
    _logs.add(output);
    logs.value = _logs.join();
    print(output);
  }

  Future<void> _getPort(List<int> data) async {
    final String output = String.fromCharCodes(data);
    if (output.contains(_portKey)) {
      _setPort(output);
    }
  }

  void _setPort(String output) {
    final int start = output.indexOf(_portKey) + _portKey.length;
    final int end = output.indexOf('\r\n');
    _port = output.substring(start, end);
    _portInitialized = true;
    unawaited(_getPortSubscription.cancel());
  }
}
