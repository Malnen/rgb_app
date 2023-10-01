import 'package:flutter/material.dart';
import 'package:rgb_app/effects/effect_data.dart';

class EffectDictionary {
  static final List<EffectData> availableEffects = <EffectData>[
    waveEffect,
    keyStrokeEffect,
    spiralEffect,
    rippleEffect,
  ];

  static final EffectData waveEffect = EffectData(
    name: 'Wave',
    className: 'WaveEffect',
    iconData: Icons.waves,
  );
  static final EffectData keyStrokeEffect = EffectData(
    name: 'Key Stroke',
    className: 'KeyStrokeEffect',
    iconData: Icons.keyboard,
  );
  static final EffectData spiralEffect = EffectData(
    name: 'Spiral',
    className: 'SpiralEffect',
    iconData: Icons.rotate_left,
  );
  static final EffectData rippleEffect = EffectData(
    name: 'Ripple',
    className: 'RippleEffect',
    iconData: Icons.circle_outlined,
  );
}
