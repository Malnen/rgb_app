import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/effects/audio_visualizer_effect/audio_visualizer_effect.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/effects/key_stroke/key_stroke_effect.dart';
import 'package:rgb_app/effects/ripple/ripple_effect.dart';
import 'package:rgb_app/effects/spiral/spiral_effect.dart';
import 'package:rgb_app/effects/wave/wave_effect.dart';

class EffectDictionary {
  static final List<EffectData> availableEffects = <EffectData>[
    waveEffect,
    keyStrokeEffect,
    spiralEffect,
    rippleEffect,
    audioVisualizer,
  ];

  static final EffectData waveEffect = EffectData.withRandomKey(
    name: WaveEffect.name,
    className: WaveEffect.className,
    iconData: Icons.waves,
  );
  static final EffectData keyStrokeEffect = EffectData.withRandomKey(
    name: KeyStrokeEffect.name,
    className: KeyStrokeEffect.className,
    iconData: Icons.keyboard,
  );
  static final EffectData spiralEffect = EffectData.withRandomKey(
    name: SpiralEffect.name,
    className: SpiralEffect.className,
    iconData: Icons.rotate_left,
  );
  static final EffectData rippleEffect = EffectData.withRandomKey(
    name: RippleEffect.name,
    className: RippleEffect.className,
    iconData: Icons.circle_outlined,
  );
  static final EffectData audioVisualizer = EffectData.withRandomKey(
    name: AudioVisualizerEffect.name,
    className: AudioVisualizerEffect.className,
    iconData: CupertinoIcons.waveform,
  );
}
