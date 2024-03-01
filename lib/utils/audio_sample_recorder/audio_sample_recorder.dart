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
  final RgbAppService _service;

  late final BehaviorSubject<List<int>> audioDataStream;
  late final WebSocketChannel _channel;

  double _audioGain;

  AudioSampleRecorder()
      : _audioGain = 0,
        _service = GetIt.instance.get();

  set audioGain(double value) {
    _audioGain = value;
  }

  void init() async {
    audioDataStream = BehaviorSubject<List<int>>.seeded(<int>[]);
    await _createWebSocketConnection();
  }

  void dispose() {
    audioDataStream.close();
    _channel.sink.close();
  }

  Future<void> _createWebSocketConnection() async {
    _channel = await _service.connect('audioSample', _channelListener);
    _service.sendCommand(RgbAppServiceRequest(command: AudioSampleCommand.createCapture.name), _channel);
  }

  void _channelListener(Object? data) {
    final String json = data.toString();
    final Map<String, Object> parsedData = Map<String, Object>.from(jsonDecode(json) as Map<String, Object?>);
    final AudioSampleResponseType responseType = AudioSampleResponseType.values.byName(
      parsedData['responseType'] as String,
    );
    switch (responseType) {
      case AudioSampleResponseType.captureCreated:
        _getAudioData();
        break;
      case AudioSampleResponseType.audioData:
        _onAudioData(parsedData);
        break;
      default:
        print(json);
        break;
    }
  }

  void _onAudioData(Map<String, Object> data) async {
    audioDataStream.value = List<int>.from(data['audioData'] as List<Object?>);
    await Future<void>.delayed(Duration(milliseconds: 10));
    _getAudioData();
  }

  void _getAudioData() {
    _service.sendCommand(
      RgbAppServiceRequest(
        command: AudioSampleCommand.getAudioSample.name,
        data: <String, Object>{
          'audioGain': _audioGain,
        },
      ),
      _channel,
    );
  }
}
