import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_effect.dart';
import 'package:rgb_app/effects/rainbow_wave_effect.dart';

class EffectFactory {
  static Effect getEffect(Map<String, dynamic> json) {
    final String className = json['className'] as String;
    switch (className) {
      case 'RainbowWaveEffect':
        return RainbowWaveEffect.fromJson(json);
      case 'KeyStrokeEffect':
        return KeyStrokeEffect.fromJson(json);
      default:
        throw Exception('Illegal effect');
    }
  }
}
