import 'dart:math';

import 'package:flutter/material.dart';

class Ripple {
  final Point<int> center;
  final Color color;

  double lifespan;

  final double _originalLifespan;

  double _radius;
  double _disappearanceRadius;
  double _fade;
  bool _canBeDeleted;
  bool _isDisappearing;

  Ripple({
    required this.center,
    required this.lifespan,
    required this.color,
  })  : _originalLifespan = lifespan,
        _radius = 0,
        _disappearanceRadius = 0,
        _fade = 0,
        _canBeDeleted = false,
        _isDisappearing = false;

  bool get canBeDeleted => _canBeDeleted;

  bool get isDisappearing => _isDisappearing;

  void update({
    required double expansionSpeed,
    required double deathSpeed,
  }) {
    _radius += expansionSpeed;
    if (_isDisappearing) {
      _disappearanceRadius += expansionSpeed;
    }

    if (lifespan > 0) {
      lifespan -= deathSpeed;
      if (lifespan < .3 * _originalLifespan && !_isDisappearing) {
        _isDisappearing = true;
        _fade = _originalLifespan;
      }
    }

    if (_isDisappearing) {
      _fade -= 0.1;
      if (_fade <= 0) {
        _canBeDeleted = true;
      }
    }
  }

  double getOpacity(Point<int> position) {
    final double distance = center.distanceTo(position);
    final double opacityValue = _getOpacityValue(distance);
    if (_isDisappearing) {
      return opacityValue * _fade / _originalLifespan;
    }

    return opacityValue;
  }

  double _getOpacityValue(double distance) {
    if (distance <= _radius) {
      if (_disappearanceRadius > 0) {
        if (distance <= _disappearanceRadius) {
          return 0;
        } else if (distance > _disappearanceRadius * 2) {
          return 1;
        }

        return (distance - _disappearanceRadius) / _disappearanceRadius;
      }

      return 1;
    } else if (distance > _radius * 2) {
      return 0;
    }

    return 1 - (distance - _radius) / _radius;
  }
}
