import 'package:flutter/material.dart';
import 'package:rgb_app/effects/effect_data.dart';

class EffectDictionary {
  static final List<EffectData> availableEffects = <EffectData>[
    rainbowWaveEffect,
    keyStrokeEffect,
    rainbowSpiralEffect,
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
  static final EffectData rainbowSpiralEffect = EffectData(
    name: 'Rainbow Spiral',
    className: 'RainbowSpiralEffect',
    iconData: Icons.public,
  );
}
