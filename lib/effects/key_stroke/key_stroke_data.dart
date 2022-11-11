import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/devices/key_dictionary.dart';
import 'package:rgb_app/devices/keyboard_key.dart';

class KeyStrokeData extends Equatable {
  final int x;
  final int y;
  final KeyboardKey? keyboardKey;
  final Color color;
  final double duration;
  final bool increment;
  final double opacity;

  KeyStrokeData({
    required this.x,
    required this.y,
    required this.keyboardKey,
    required this.color,
    required this.duration,
    this.increment = true,
    this.opacity = 0,
  });

  factory KeyStrokeData.create({
    required String coords,
    required Color color,
    required double duration,
  }) {
    final int x = KeyDictionary.getX(coords);
    final int y = KeyDictionary.getY(coords);
    final Map<String, KeyboardKey> keys = KeyDictionary.keys;
    final KeyboardKey? keyboardKey = keys[coords];

    return KeyStrokeData(
      x: x,
      y: y,
      color: color,
      duration: duration,
      keyboardKey: keyboardKey,
    );
  }

  KeyStrokeData copyWith({
    int? x,
    int? y,
    Color? color,
    double? duration,
    KeyboardKey? keyboardKey,
    bool? increment,
    double? opacity,
  }) {
    return KeyStrokeData(
      x: x ?? this.x,
      y: y ?? this.y,
      color: color ?? this.color,
      duration: duration ?? this.duration,
      keyboardKey: keyboardKey ?? this.keyboardKey,
      increment: increment ?? this.increment,
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  List<Object?> get props => [
        x,
        y,
        keyboardKey,
        color,
        duration,
        opacity,
        increment,
      ];
}
