import 'package:flutter/material.dart';
import 'package:rgb_app/models/color_list.dart';
import 'package:vector_math/vector_math.dart' as vmath;

extension ColorListExtension on ColorList {
  Color getTransformedColor({
    required int x,
    required int y,
    required int z,
    required vmath.Vector3 size,
    required vmath.Vector3 scale,
    required vmath.Vector3 offset,
    required vmath.Vector3 rotation,
  }) {
    final vmath.Vector3 centerOffset = vmath.Vector3(
      size.x * scale.x / 2,
      size.y * scale.y / 2,
      size.z * scale.z / 2,
    );

    final vmath.Matrix4 model = vmath.Matrix4.identity()
      ..translate(offset.x, offset.y, offset.z)
      ..translate(centerOffset.x, centerOffset.y, centerOffset.z)
      ..rotateX(vmath.radians(rotation.x))
      ..rotateY(vmath.radians(rotation.y))
      ..rotateZ(vmath.radians(rotation.z))
      ..translate(-centerOffset.x, -centerOffset.y, -centerOffset.z)
      ..scale(size.x * scale.x, size.y * scale.y, size.z * scale.z);

    final vmath.Vector3 localPoint = vmath.Vector3(
      x / size.x,
      y / size.y,
      z / size.z,
    );

    final vmath.Vector3 worldPoint = model.transform3(localPoint);

    final double fx = worldPoint.x.clamp(0, width - 1.0);
    final double fy = worldPoint.y.clamp(0, height - 1.0);
    final double fz = worldPoint.z.clamp(0, depth - 1.0);

    final int x0 = fx.floor().clamp(0, width - 1);
    final int x1 = (x0 + 1).clamp(0, width - 1);
    final int y0 = fy.floor().clamp(0, height - 1);
    final int y1 = (y0 + 1).clamp(0, height - 1);
    final int z0 = fz.floor().clamp(0, depth - 1);
    final int z1 = (z0 + 1).clamp(0, depth - 1);

    final double tx = fx - fx.floor();
    final double ty = fy - fy.floor();
    final double tz = fz - fz.floor();

    final Color c000 = getColor(x0, y0, z0);
    final Color c100 = getColor(x1, y0, z0);
    final Color c010 = getColor(x0, y1, z0);
    final Color c110 = getColor(x1, y1, z0);
    final Color c001 = getColor(x0, y0, z1);
    final Color c101 = getColor(x1, y0, z1);
    final Color c011 = getColor(x0, y1, z1);
    final Color c111 = getColor(x1, y1, z1);

    final Color c00 = _lerp(c000, c100, tx);
    final Color c10 = _lerp(c010, c110, tx);
    final Color c01 = _lerp(c001, c101, tx);
    final Color c11 = _lerp(c011, c111, tx);

    final Color c0 = _lerp(c00, c10, ty);
    final Color c1 = _lerp(c01, c11, ty);

    return _lerp(c0, c1, tz);
  }

  Color _lerp(Color a, Color b, double t) {
    return Color.fromARGB(
      _lerpChannel(a.alpha, b.alpha, t),
      _lerpChannel(a.red, b.red, t),
      _lerpChannel(a.green, b.green, t),
      _lerpChannel(a.blue, b.blue, t),
    );
  }

  int _lerpChannel(int a, int b, double t) {
    return (a + (b - a) * t).round().clamp(0, 255);
  }
}
