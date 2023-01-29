import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_effect.dart';
import 'package:rgb_app/effects/rainbow_spiral_effect/rainbow_spiral_effect.dart';
import 'package:rgb_app/effects/rainbow_wave_effect.dart';

class EffectFactory {
  static Effect getEffectFromJson(Map<String, dynamic> json) {
    final String className = json['className'] as String;
    switch (className) {
      case 'RainbowWaveEffect':
        return RainbowWaveEffect.fromJson(json);
      case 'KeyStrokeEffect':
        return KeyStrokeEffect.fromJson(json);
      case 'RainbowSpiralEffect':
        return RainbowSpiralEffect.fromJson(json);
      default:
        throw Exception('Illegal effect');
    }
  }

  static Effect getEffectByClassName(String className) {
    final EffectData effectData = _getCorrectEffectData(className);

    switch (className) {
      case 'RainbowWaveEffect':
        return RainbowWaveEffect(
          effectData: effectData,
        );
      case 'KeyStrokeEffect':
        return KeyStrokeEffect(
          effectData: effectData,
        );
      case 'RainbowSpiralEffect':
        return RainbowSpiralEffect(
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
