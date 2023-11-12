import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:rgb_app/utils/assets_loader.dart';
import 'package:rgb_app/utils/rgb_app_service/models/rgb_app_service_request.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RgbAppService {
  static const String _portKey = '_PORT_';

  late Process _process;
  late StreamSubscription<List<int>> _getPortSubscription;
  late String _port;

  bool _portInitialized = false;

  void init() async {
    final String executablePath = AssetsLoader.getAssetPath(
      name: 'rgbAppService/RgbAppService.exe',
      withAbsolutePath: true,
    );
    _process = await Process.start(executablePath, <String>[]);
    final Stream<List<int>> stdout = _process.stdout.asBroadcastStream();
    stdout.listen(_decode);
    _getPortSubscription = stdout.listen(_getPort);
    _process.stderr.listen(_decode);
  }

  Future<WebSocketChannel> connect(String channel, void Function(Object?) callback) async {
    while (!_portInitialized) {
      await Future<void>.delayed(Duration(seconds: 1));
    }

    final Uri uri = Uri.parse('ws://localhost:$_port/$channel');
    final WebSocketChannel webSocketChannel = WebSocketChannel.connect(uri);
    webSocketChannel.stream.listen(callback);
    await Future<void>.delayed(Duration(milliseconds: 100));

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
