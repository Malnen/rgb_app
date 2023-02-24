import 'package:flutter/material.dart';
import 'package:rgb_app/effects/effect_data.dart';

class EffectDictionary {
  static final List<EffectData> availableEffects = <EffectData>[
    waveEffect,
    keyStrokeEffect,
    spiralEffect,
  ];

  static final EffectData waveEffect = EffectData(
    name: 'Wave',
    className: 'WaveEffect',
    iconData: Icons.waves,
  );
  static final EffectData keyStrokeEffect = EffectData(
    name: 'Key Stroke',
    className: 'KeyStrokeEffect',
    iconData: Icons.public,
  );
  static final EffectData spiralEffect = EffectData(
    name: 'Spiral',
    className: 'SpiralEffect',
    iconData: Icons.public,
  );
}
