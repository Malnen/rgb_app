import 'package:rgb_app/effects/audio_visualizer_effect/audio_visualizer_effect.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/effects/effect_dictionary.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_effect.dart';
import 'package:rgb_app/effects/ripple/ripple_effect.dart';
import 'package:rgb_app/effects/spiral/spiral_effect.dart';
import 'package:rgb_app/effects/wave/wave_effect.dart';

class EffectFactory {
  static Effect getEffectFromJson(Map<String, Object?> json) {
    final String className = json['className'] as String;
    final Effect effect = getEffectByClassName(className);
    effect.updatePropertiesFromJson(json);

    return effect;
  }

  static Effect getEffectByClassName(String className) {
    final EffectData effectData = _getCorrectEffectData(className);
    return switch (className) {
      WaveEffect.className => WaveEffect(effectData),
      KeyStrokeEffect.className => KeyStrokeEffect(effectData),
      SpiralEffect.className => SpiralEffect(effectData),
      RippleEffect.className => RippleEffect(effectData),
      AudioVisualizerEffect.className => AudioVisualizerEffect(effectData),
      _ => throw Exception('Illegal effect')
    };
  }

  static EffectData _getCorrectEffectData(String className) {
    final EffectData effectData = EffectDictionary.availableEffects.firstWhere(
      (EffectData effectData) => effectData.className == className,
    );

    return EffectData.getWithNewKey(effectData);
  }
}
