import 'dart:async';
import 'dart:convert';

import 'package:rgb_app/utils/audio_sample_recorder/enums/audio_sample_command.dart';
import 'package:rgb_app/utils/audio_sample_recorder/enums/audio_sample_response_type.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service_listener.dart';
import 'package:rxdart/rxdart.dart';

class AudioSampleRecorder with RgbAppServiceListener<AudioSampleResponseType, AudioSampleCommand> {
  late final BehaviorSubject<List<int>> audioDataStream;

  double _audioGain;

  AudioSampleRecorder() : _audioGain = 0;

  @override
  String get channelName => 'audioSample';

  @override
  void Function(AudioSampleResponseType, Map<String, Object>) get processResponse => _channelListener;

  @override
  Iterable<AudioSampleResponseType> get responseTypes => AudioSampleResponseType.values;

  set audioGain(double value) => _audioGain = value;

  @override
  Future<void> init() async {
    audioDataStream = BehaviorSubject<List<int>>.seeded(<int>[]);
    await super.init();
    sendCommand(AudioSampleCommand.createCapture);
  }

  @override
  void dispose() {
    audioDataStream.close();
    super.dispose();
  }

  void _channelListener(AudioSampleResponseType responseType, Map<String, Object> parsedData) {
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
    sendCommand(
      AudioSampleCommand.getAudioSample,
      data: <String, Object>{
        'audioGain': _audioGain,
      },
    );
  }
}
