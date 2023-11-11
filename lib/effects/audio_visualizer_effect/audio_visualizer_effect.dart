import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/factories/property_factory.dart';
import 'package:rgb_app/models/color_property.dart' as color;
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/utils/audio_sample_recorder/audio_sample_recorder.dart';
import 'package:rxdart/rxdart.dart';

class AudioVisualizerEffect extends Effect {
  static const String className = 'AudioVisualizerEffect';
  static const String name = 'Audio Visualizer';

  late AudioSampleRecorder recorder;

  @override
  List<Property<Object>> get properties => <Property<Object>>[
        boost,
        pulseRate,
        spectrumSize,
        spectrumShift,
        disabledOnIdle,
        barsColorMode,
        if (!_areBarsTransparent) barsColor,
        backgroundColorMode,
        if (!_isBackgroundTransparent) backgroundColor,
      ];

  final ValueNotifier<bool> _disabled = ValueNotifier<bool>(false);

  late NumericProperty boost;
  late NumericProperty pulseRate;
  late NumericProperty spectrumSize;
  late NumericProperty spectrumShift;
  late color.ColorProperty barsColor;
  late color.ColorProperty backgroundColor;
  late OptionProperty barsColorMode;
  late OptionProperty disabledOnIdle;
  late OptionProperty backgroundColorMode;
  late List<int> _currentValues;

  bool _isBackgroundTransparent = false;
  bool _areBarsTransparent = false;
  bool _disableOnIdle = false;
  bool _hasAudioData = false;
  bool _duringTransition = false;
  double _transitionOpacity = 0;
  Timer? _idleTimer;
  Timer? _transitionTimer;

  AudioVisualizerEffect(super.effectData)
      : boost = NumericProperty(
          initialValue: -100,
          name: 'Boost',
          min: -200,
          max: 200,
        ),
        pulseRate = NumericProperty(
          initialValue: 25,
          name: 'Pulse Rate',
          min: 1,
          max: 50,
        ),
        spectrumSize = NumericProperty(
          initialValue: 25,
          name: 'Spectrum Size',
          min: 1,
          max: 512,
        ),
        spectrumShift = NumericProperty(
          initialValue: 25,
          name: 'Spectrum Shift',
          min: 0,
          max: 512,
        ),
        barsColor = color.ColorProperty(
          initialValue: Colors.white,
          name: 'Bars Color',
        ),
        backgroundColor = color.ColorProperty(
          initialValue: Colors.white,
          name: 'Background Color',
        ),
        disabledOnIdle = OptionProperty(
          initialValue: <Option>{
            Option(
              value: 0,
              name: 'Yes',
              selected: false,
            ),
            Option(
              value: 1,
              name: 'No',
              selected: true,
            ),
          },
          name: 'Disable On Idle',
        ),
        barsColorMode = OptionProperty(
          initialValue: <Option>{
            Option(
              value: 0,
              name: 'Transparent',
              selected: false,
            ),
            Option(
              value: 1,
              name: 'Color',
              selected: true,
            ),
          },
          name: 'Bars Color Mode',
        ),
        backgroundColorMode = OptionProperty(
          initialValue: <Option>{
            Option(
              value: 0,
              name: 'Transparent',
              selected: true,
            ),
            Option(
              value: 1,
              name: 'Color',
              selected: false,
            ),
          },
          name: 'Background Color Mode',
        ) {
    recorder = AudioSampleRecorder();
    recorder.init();
    _currentValues = <int>[];
    _disabled.addListener(_onDisableChange);
  }

  @override
  Map<String, Object?> getData() {
    return <String, Object>{
      'boost': boost.toJson(),
      'pulseRate': pulseRate.toJson(),
      'spectrumSize': spectrumSize.toJson(),
      'spectrumShift': spectrumShift.toJson(),
      'disabledOnIdle': disabledOnIdle.toJson(),
      'barsColor': barsColor.toJson(),
      'barsColorMode': barsColorMode.toJson(),
      'backgroundColor': backgroundColor.toJson(),
      'backgroundColorMode': backgroundColorMode.toJson(),
    };
  }

  @override
  void init() {
    barsColorMode.addValueChangeListener(_onBarsColorModeChange);
    backgroundColorMode.addValueChangeListener(_onBackgroundColorModeChange);
    disabledOnIdle.addValueChangeListener(_onDisableOnIdle);
    super.init();
  }

  @override
  void update() {
    // ignore: close_sinks
    final BehaviorSubject<List<int>> audioDataStream = recorder.audioDataStream;
    final List<int> value = audioDataStream.value;
    if (value.isNotEmpty) {
      _manageIdleTimer(value);
      if (!_disabled.value || _duringTransition) {
        _updateColors(value);
      }
    }
  }

  void _onDisableChange() {
    _duringTransition = true;
    _transitionTimer?.cancel();
    _transitionTimer = Timer.periodic(Duration(milliseconds: 25), (_) {
      _transitionOpacity += 0.05 * (_disabled.value ? -1 : 1);
      if (_transitionOpacity > 1 || _transitionOpacity < 0) {
        _transitionOpacity = _disabled.value ? 0 : 1;
        _duringTransition = false;
        _transitionTimer?.cancel();
        _transitionTimer = null;
      }
    });
  }

  void _manageIdleTimer(List<int> value) {
    if (_disableOnIdle) {
      _hasAudioData = value.any((int element) => element > 0);
      if (!_hasAudioData) {
        _idleTimer ??= Timer(Duration(seconds: 8), () {
          _disabled.value = true;
        });
      } else {
        _idleTimer?.cancel();
        _idleTimer = null;
        _disabled.value = false;
      }
    }
  }

  void _onBarsColorModeChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option option) => option.selected);
    _areBarsTransparent = selectedOption.value == 0;
  }

  void _onBackgroundColorModeChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option option) => option.selected);
    _isBackgroundTransparent = selectedOption.value == 0;
  }

  void _onDisableOnIdle(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option option) => option.selected);
    _disableOnIdle = selectedOption.value == 0;
    if (!_disableOnIdle) {
      _disabled.value = false;
    }
  }

  void _updateColors(List<int> value) {
    final int length = _calculateLengthAndCorrectCurrentValues();
    _currentValues = _resizeValue(value, length).map(_applyBoost).indexed.map(_processCurrentValue).toList();
    _processUpdatedValues();
  }

  int _calculateLengthAndCorrectCurrentValues() {
    final int sizeX = effectBloc.sizeX;
    final int sizeValue = spectrumSize.value.toInt();
    final int length = sizeX > sizeValue ? sizeX : sizeValue;
    if (_currentValues.length != length) {
      _currentValues = List<int>.filled(length, 0);
    }

    return length;
  }

  Iterable<int> _resizeValue(List<int> source, int targetLength) sync* {
    final int sourceLength = source.length;
    final int step = sourceLength ~/ targetLength;
    for (int i = 0; i < targetLength; i++) {
      int sum = 0;
      for (int j = 0; j < step; j++) {
        final int index = step * i + j;
        sum += index < sourceLength ? source[index] : sum += source.last;
      }

      yield sum ~/ step;
    }
  }

  int _applyBoost(int value) => value + boost.value.toInt();

  int _processCurrentValue((int index, int value) record) {
    int currentValue = _currentValues[record.$1];
    final int newValue = record.$2;
    final int difference = (currentValue - newValue).abs();
    final int barValue = pulseRate.value.toInt();
    if (barValue > difference) {
      currentValue = newValue;
    } else if (newValue > currentValue) {
      currentValue += barValue;
    } else if (newValue < currentValue) {
      currentValue -= barValue;
    }

    if (currentValue > 100) {
      currentValue = 100;
    } else if (currentValue < 0) {
      currentValue = 0;
    }

    _currentValues[record.$1] = currentValue;
    return currentValue;
  }

  void _processUpdatedValues() {
    final List<List<Color>> colors = effectsColorsCubit.colors;
    final int sizeY = effectBloc.sizeY;
    final int step = 100 ~/ sizeY;
    final int spectrumShiftValue = spectrumShift.value.toInt();
    final int sizeX = effectBloc.sizeX;
    final int spectrumOffset = spectrumShiftValue > _currentValues.length - sizeX ? 0 : spectrumShiftValue;
    for (int i = 0; i < sizeX; i++) {
      final int value = _currentValues[i + spectrumOffset];
      for (int j = 0; j < sizeY; j++) {
        final int y = sizeY - 1 - j;
        final Color currentColor = colors[y][i];
        _setColor(step, j, i, value, sizeY, colors, y, currentColor);
        if (_duringTransition) {
          final Color currentNewColor = colors[y][i];
          colors[y][i] = ColorExtension.mix(currentNewColor, currentColor, _transitionOpacity);
        }
      }
    }
  }

  void _setColor(int step, int j, int i, int value, int sizeY, List<List<Color>> colors, int y, Color currentColor) {
    final double opacity = _calculateOpacity(step, j, value);
    final Color barsColorValue = _areBarsTransparent ? currentColor : barsColor.value;
    final Color backgroundColorValue = _isBackgroundTransparent ? currentColor : backgroundColor.value;
    colors[y][i] = ColorExtension.mix(barsColorValue, backgroundColorValue, opacity);
  }

  double _calculateOpacity(int step, int j, int value) {
    final int currentStep = step * (j + 1);
    if (value > currentStep) {
      return 1;
    } else {
      final int difference = currentStep - value;
      if (difference > 0 && difference < step) {
        return difference / step;
      }
    }

    return 0;
  }

  @override
  void dispose() {
    recorder.dispose();
  }

  factory AudioVisualizerEffect.fromJson(Map<String, Object?> json) {
    final AudioVisualizerEffect effect = AudioVisualizerEffect(EffectDictionary.audioVisualizer);
    effect.boost = PropertyFactory.getProperty(json['boost'] as Map<String, Object?>);
    effect.pulseRate = PropertyFactory.getProperty(json['pulseRate'] as Map<String, Object?>);
    effect.spectrumSize = PropertyFactory.getProperty(json['spectrumSize'] as Map<String, Object?>);
    effect.spectrumShift = PropertyFactory.getProperty(json['spectrumShift'] as Map<String, Object?>);
    effect.barsColor = PropertyFactory.getProperty(json['barsColor'] as Map<String, Object?>);
    effect.backgroundColor = PropertyFactory.getProperty(json['backgroundColor'] as Map<String, Object?>);
    effect.barsColorMode = PropertyFactory.getProperty(json['barsColorMode'] as Map<String, Object?>);
    effect.backgroundColorMode = PropertyFactory.getProperty(json['backgroundColorMode'] as Map<String, Object?>);
    effect.disabledOnIdle = PropertyFactory.getProperty(json['disabledOnIdle'] as Map<String, Object?>);

    return effect;
  }
}
