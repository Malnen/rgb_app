import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rgb_app/effects/audio_visualizer_effect/audio_visualizer_effect_properties.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/utils/audio_sample_recorder/audio_sample_recorder.dart';
import 'package:rgb_app/utils/tick_provider.dart';
import 'package:rxdart/rxdart.dart';

class AudioVisualizerEffect extends Effect with AudioVisualizerEffectProperties {
  static const String className = 'AudioVisualizerEffect';
  static const String name = 'Audio Visualizer';

  late AudioSampleRecorder recorder;

  final ValueNotifier<bool> _disabled = ValueNotifier<bool>(false);
  late List<int> _currentValues;

  final double _dynamicBoostSpeed = 2;
  final double _dynamicBoostCeil = 75;

  bool _isBackgroundTransparent = false;
  bool _areBarsTransparent = false;
  bool _disableOnIdle = false;
  bool _hasAudioData = false;
  bool _duringTransition = false;
  bool _useDynamicBoost = true;
  double _transitionOpacity = 0;
  double _dynamicBoostValue = 0;
  int _maxAudioValue = 0;
  Timer? _idleTimer;
  Timer? _transitionTimer;

  AudioVisualizerEffect(super.effectData) {
    initProperties();
    recorder = AudioSampleRecorder();
    recorder.init();
    _currentValues = <int>[];
    _disabled.addListener(_onDisableChange);
  }

  @override
  void init() {
    barsColorMode.addValueChangeListener(_onBarsColorModeChange);
    backgroundColorMode.addValueChangeListener(_onBackgroundColorModeChange);
    disabledOnIdle.addValueChangeListener(_onDisableOnIdle);
    audioGain.addValueChangeListener((double value) {
      recorder.audioGain = value;
    });
    dynamicBoost.addValueChangeListener(_onDynamicBoostChange);
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

  @override
  void dispose() {
    recorder.dispose();
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
    barsColor.visible = !_areBarsTransparent;
  }

  void _onBackgroundColorModeChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option option) => option.selected);
    _isBackgroundTransparent = selectedOption.value == 0;
    backgroundColor.visible = !_isBackgroundTransparent;
  }

  void _onDisableOnIdle(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option option) => option.selected);
    _disableOnIdle = selectedOption.value == 0;
    if (!_disableOnIdle) {
      _disabled.value = false;
    }
  }

  void _onDynamicBoostChange(Set<Option> options) {
    final Option selectedOption = options.firstWhere((Option option) => option.selected);
    _useDynamicBoost = selectedOption.value == 0;
    boost.visible = !_useDynamicBoost;
  }

  void _updateColors(List<int> value) {
    final int length = _calculateLengthAndCorrectCurrentValues();
    final Iterable<int> values = _resizeValue(value, length);
    if (_useDynamicBoost) {
      _manageDynamicBoost();
    }

    _currentValues = values.map(_applyBoost).indexed.map(_processCurrentValue).toList();
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
    _maxAudioValue = -1000;
    for (int i = 0; i < targetLength; i++) {
      int sum = 0;
      for (int j = 0; j < step; j++) {
        final int index = step * i + j;
        sum += index < sourceLength ? source[index] : sum += source.last;
      }

      final int value = sum ~/ step;
      if (value > _maxAudioValue) {
        _maxAudioValue = value;
      }

      yield value;
    }
  }

  void _manageDynamicBoost() {
    if (_maxAudioValue < -75) {
      _maxAudioValue = 0;
    }

    final double boostValue = _dynamicBoostCeil - _maxAudioValue;
    final double difference = (_dynamicBoostCeil - boostValue).abs();
    if (difference < _dynamicBoostSpeed) {
      _dynamicBoostValue = boostValue;
    } else if (_dynamicBoostValue > boostValue) {
      _dynamicBoostValue -= _dynamicBoostSpeed;
    } else if (_dynamicBoostValue < boostValue) {
      _dynamicBoostValue += _dynamicBoostSpeed;
    }
  }

  int _applyBoost(int value) {
    if (_useDynamicBoost) {
      return value + _dynamicBoostValue.toInt();
    }

    return value + boost.value.toInt();
  }

  int _processCurrentValue((int index, int value) record) {
    int currentValue = _currentValues[record.$1];
    final int newValue = record.$2;
    final int difference = (currentValue - newValue).abs();
    final int barValue = (pulseRate.value * TickProvider.fpsMultiplier).toInt();
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
    final int sizeZ = effectBloc.sizeZ;
    final int step = 100 ~/ sizeZ;
    final int spectrumShiftValue = spectrumShift.value.toInt();
    final int sizeX = effectBloc.sizeX;
    final int spectrumOffset = spectrumShiftValue > _currentValues.length - sizeX ? 0 : spectrumShiftValue;
    processUsedIndexes(
      (int x, int yIndex, int z) {
        final int value = _currentValues[x + spectrumOffset];
        final int y = sizeZ - 1 - yIndex;
        final Color currentColor = colors.getColor(x, yIndex, 0);
        _setColor(step, yIndex, x, value, sizeZ, y, currentColor);
        if (_duringTransition) {
          final Color currentNewColor = colors.getColor(x, y, 0);
          colors.setColor(x, y, 0, currentNewColor.mix(currentColor, _transitionOpacity));
        }
      },
    );
  }

  void _setColor(int step, int j, int i, int value, int sizeZ, int y, Color currentColor) {
    final int selectedId = displayMode.selectedOption.value;
    if (selectedId == 0) {
      _onNormalDisplay(step, j, value, currentColor, y, i);
    } else if (selectedId == 1) {
      _onMirroredDisplay(step, j, value ~/ 2, currentColor, y, i);
    }
  }

  void _onNormalDisplay(int step, int j, int value, Color currentColor, int y, int i) {
    final double opacity = _calculateOpacity(step, j, value);
    final Color barsColorValue = _areBarsTransparent ? currentColor : barsColor.value;
    final Color backgroundColorValue = _isBackgroundTransparent ? currentColor : backgroundColor.value;
    colors.setColor(i, j, 0, barsColorValue.mix(backgroundColorValue, opacity));
  }

  void _onMirroredDisplay(int step, int j, int value, Color currentColor, int y, int i) {
    final int halfOfHeight = effectBloc.sizeZ ~/ 2;
    late double opacity;
    if (y < halfOfHeight) {
      opacity = _calculateOpacity(step, j - halfOfHeight, value);
    } else {
      opacity = 1 - _calculateOpacity(step, j + halfOfHeight, 100 - value);
    }

    final Color barsColorValue = _areBarsTransparent ? currentColor : barsColor.value;
    final Color backgroundColorValue = _isBackgroundTransparent ? currentColor : backgroundColor.value;
    colors.setColor(i, j, 0, barsColorValue.mix(backgroundColorValue, opacity));
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
}
