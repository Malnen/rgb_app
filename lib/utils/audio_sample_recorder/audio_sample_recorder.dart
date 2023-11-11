import 'dart:async';
import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:rgb_app/utils/audio_sample_recorder/enums/audio_sample_command.dart';
import 'package:rgb_app/utils/audio_sample_recorder/enums/audio_sample_response_type.dart';
import 'package:rgb_app/utils/rgb_app_service/models/rgb_app_service_request.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AudioSampleRecorder {
  late final BehaviorSubject<List<int>> audioDataStream;
  late final WebSocketChannel _channel;

  late Timer _getAudioSampleTimer;

  void init() async {
    audioDataStream = BehaviorSubject<List<int>>.seeded(<int>[]);
    await _createWebSocketConnection();
  }

  void dispose() {
    _getAudioSampleTimer.cancel();
    audioDataStream.close();
    _channel.sink.close();
  }

  Future<void> _createWebSocketConnection() async {
    final RgbAppService service = GetIt.instance.get();
    _channel = await service.connect('audioSample', _channelListener);
    service.sendCommand(RgbAppServiceRequest(AudioSampleCommand.createCapture.name), _channel);
    _getAudioSampleTimer = Timer.periodic(Duration(milliseconds: 10), (_) {
      service.sendCommand(RgbAppServiceRequest(AudioSampleCommand.getAudioSample.name), _channel);
    });
  }

  void _channelListener(Object? data) {
    final String json = data.toString();
    final Map<String, Object> parsedData = Map<String, Object>.from(jsonDecode(json) as Map<String, Object?>);
    final AudioSampleResponseType responseType = AudioSampleResponseType.values.byName(
      parsedData['responseType'] as String,
    );
    switch (responseType) {
      case AudioSampleResponseType.audioData:
        _onAudioData(parsedData);
        break;
      default:
        print(json);
        break;
    }
  }

  void _onAudioData(Map<String, Object> data) {
    audioDataStream.value = List<int>.from(data['audioData'] as List<Object?>).map((int value) => value + 150).toList();
  }
}
