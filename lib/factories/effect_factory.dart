import 'package:rgb_app/effects/audio_visualizer_effect/audio_visualizer_effect.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_effect.dart';
import 'package:rgb_app/effects/ripple/ripple_effect.dart';
import 'package:rgb_app/effects/spiral/spiral_effect.dart';
import 'package:rgb_app/effects/wave_effect.dart';

class EffectFactory {
  static Effect getEffectFromJson(Map<String, Object?> json) {
    final String className = json['className'] as String;
    switch (className) {
      case WaveEffect.className:
        return WaveEffect.fromJson(json);
      case KeyStrokeEffect.className:
        return KeyStrokeEffect.fromJson(json);
      case SpiralEffect.className:
        return SpiralEffect.fromJson(json);
      case RippleEffect.className:
        return RippleEffect.fromJson(json);
      case AudioVisualizerEffect.className:
        return AudioVisualizerEffect.fromJson(json);
      default:
        throw Exception('Illegal effect');
    }
  }

  static Effect getEffectByClassName(String className) {
    final EffectData effectData = _getCorrectEffectData(className);
    switch (className) {
      case WaveEffect.className:
        return WaveEffect(effectData);
      case KeyStrokeEffect.className:
        return KeyStrokeEffect(effectData);
      case SpiralEffect.className:
        return SpiralEffect(effectData);
      case RippleEffect.className:
        return RippleEffect(effectData);
      case AudioVisualizerEffect.className:
        return AudioVisualizerEffect(effectData);
      default:
        throw Exception('Illegal effect');
    }
  }

  static EffectData _getCorrectEffectData(String className) {
    final EffectData effectData =
    EffectDictionary.availableEffects.firstWhere((EffectData effectData) => effectData.className == className);
    return effectData.getWithNewKey();
  }
}
