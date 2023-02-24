import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_effect.dart';
import 'package:rgb_app/effects/spiral_effect/spiral_effect.dart';
import 'package:rgb_app/effects/wave_effect.dart';

class EffectFactory {
  static Effect getEffectFromJson(Map<String, dynamic> json) {
    final String className = json['className'] as String;
    switch (className) {
      case 'WaveEffect':
        return WaveEffect.fromJson(json);
      case 'KeyStrokeEffect':
        return KeyStrokeEffect.fromJson(json);
      case 'SpiralEffect':
        return SpiralEffect.fromJson(json);
      default:
        throw Exception('Illegal effect');
    }
  }

  static Effect getEffectByClassName(String className) {
    final EffectData effectData = _getCorrectEffectData(className);

    switch (className) {
      case 'WaveEffect':
        return WaveEffect(
          effectData: effectData,
        );
      case 'KeyStrokeEffect':
        return KeyStrokeEffect(
          effectData: effectData,
        );
      case 'SpiralEffect':
        return SpiralEffect(
          effectData: effectData,
        );
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
