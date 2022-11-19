import 'package:flutter/material.dart';
import 'package:rgb_app/effects/effect_data.dart';

class EffectDictionary {
  static final List<EffectData> availableEffects = [
    rainbowWaveEffect,
    keyStrokeEffect,
  ];

  static final EffectData rainbowWaveEffect = EffectData(
    name: 'Rainbow Waves',
    className: 'RainbowWaveEffect',
    iconData: Icons.waves,
  );
  static final EffectData keyStrokeEffect = EffectData(
    name: 'Key Stroke',
    className: 'KeyStrokeEffect',
    iconData: Icons.public,
  );
}
