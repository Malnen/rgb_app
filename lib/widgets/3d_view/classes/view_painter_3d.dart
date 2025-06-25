import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/color_list.dart';
import 'package:vector_math/vector_math.dart' as vmath;

class ViewPainter3D extends CustomPainter {
  final List<DeviceInterface> devices;
  final double rotationX;
  final double rotationY;
  final double zoomFactor;
  final Offset translationOffset;
  final bool showEffects;

  ViewPainter3D({
    required this.devices,
    required this.rotationX,
    required this.rotationY,
    required this.zoomFactor,
    required this.translationOffset,
    required this.showEffects,
  });

  List<vmath.Vector4> _clipFaceAgainstNearPlane(List<vmath.Vector4> face, double nearZ) {
    final List<vmath.Vector4> result = <vmath.Vector4>[];
    for (int i = 0; i < face.length; i++) {
      final vmath.Vector4 current = face[i];
      final vmath.Vector4 next = face[(i + 1) % face.length];
      final bool currentInside = current.z <= -nearZ;
      final bool nextInside = next.z <= -nearZ;
      if (currentInside && nextInside) {
        result.add(next);
      } else if (currentInside && !nextInside) {
        final double t = (current.z + nearZ) / (current.z - next.z);
        final vmath.Vector4 intersect = current + (next - current) * t;
        result.add(intersect);
      } else if (!currentInside && nextInside) {
        final double t = (current.z + nearZ) / (current.z - next.z);
        final vmath.Vector4 intersect = current + (next - current) * t;
        result.add(intersect);
        result.add(next);
      }
    }

    return result;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final double fovY = vmath.radians(60);
    final double aspect = size.width / size.height;
    final double near = 10.0;
    final double far = 500.0;
    final double f = 1.0 / tan(fovY / 2);

    final vmath.Matrix4 projection = vmath.Matrix4.zero()
      ..setEntry(0, 0, f / aspect)..setEntry(1, 1, f)..setEntry(2, 2, (far + near) / (near - far))..setEntry(
        2,
        3,
        (2 * far * near) / (near - far),
      )..setEntry(3, 2, -1.0);

    final double effectiveZoom = zoomFactor.clamp(0.2, 5.0);
    final vmath.Matrix4 view = vmath.Matrix4.identity()
      ..translate(0.0, 0.0, -200.0 / effectiveZoom)
      ..rotateX(rotationX)
      ..rotateY(rotationY)
      ..translate(translationOffset.dx, translationOffset.dy);

    _drawPlane(canvas, size, center, view, projection, axis: 'xy', color: Colors.grey.withAlpha(40));
    _drawPlane(canvas, size, center, view, projection, axis: 'yz', color: Colors.blue.withAlpha(20));
    _drawPlane(canvas, size, center, view, projection, axis: 'xz', color: Colors.green.withAlpha(20));

    final DevicesBloc devicesBloc = GetIt.instance.get();
    final EffectsColorsCubit effectsColorsCubit = GetIt.instance.get();
    final ColorList colorList = effectsColorsCubit.state.colors;

    for (final DeviceInterface device in devices) {
      final vmath.Vector3 offset = device.deviceData.offset;
      final vmath.Vector3 sizeVec = device.getSize();
      final vmath.Vector3 scaleVec = device.deviceData.scale;
      final vmath.Vector3 rotationVec = device.deviceData.rotation;

      final vmath.Vector3 scaledSize = vmath.Vector3(
        sizeVec.x * scaleVec.x,
        sizeVec.y * scaleVec.y,
        sizeVec.z * scaleVec.z,
      );

      final vmath.Vector3 centerOffset = scaledSize / 2;

      final vmath.Matrix4 model = vmath.Matrix4.identity()
        ..translate(offset.x, offset.y, offset.z)
        ..translate(centerOffset.x, centerOffset.y, centerOffset.z)
        ..rotateX(vmath.radians(rotationVec.x))
        ..rotateY(vmath.radians(rotationVec.y))
        ..rotateZ(vmath.radians(rotationVec.z))
        ..translate(-centerOffset.x, -centerOffset.y, -centerOffset.z);

      final vmath.Matrix4 viewModel = view.multiplied(model);

      final List<vmath.Vector3> cube = <vmath.Vector3>[
        vmath.Vector3(0, 0, 0),
        vmath.Vector3(scaledSize.x, 0, 0),
        vmath.Vector3(scaledSize.x, scaledSize.y, 0),
        vmath.Vector3(0, scaledSize.y, 0),
        vmath.Vector3(0, 0, scaledSize.z),
        vmath.Vector3(scaledSize.x, 0, scaledSize.z),
        vmath.Vector3(scaledSize.x, scaledSize.y, scaledSize.z),
        vmath.Vector3(0, scaledSize.y, scaledSize.z),
      ];

      final List<List<int>> faces = <List<int>>[
        <int>[0, 1, 2, 3],
        <int>[4, 5, 6, 7],
        <int>[0, 1, 5, 4],
        <int>[2, 3, 7, 6],
        <int>[0, 3, 7, 4],
        <int>[1, 2, 6, 5],
      ];

      final Paint paint = Paint()
        ..color = devicesBloc.state.selectedDevice == device ? Colors.orange.withAlpha(128) : Colors.white60.withAlpha(76)
        ..style = PaintingStyle.fill;

      for (final List<int> face in faces) {
        final List<vmath.Vector4> viewFace =
            face.map((int i) => viewModel.transform(vmath.Vector4(cube[i].x, cube[i].y, cube[i].z, 1))).toList();
        final List<vmath.Vector4> clipped = _clipFaceAgainstNearPlane(viewFace, near);

        if (clipped.length < 3) continue;

        final List<Offset> projected = clipped.map((vmath.Vector4 v) {
          final vmath.Vector4 p = projection.transform(v);
          final double w = p.w != 0 ? p.w : 1.0;
          return Offset((p.x / w) * size.width / 2 + center.dx, (-p.y / w) * size.height / 2 + center.dy);
        }).toList();
        canvas.drawPath(Path()..addPolygon(projected, true), paint);
      }
      final Set<int> usedIndexes = device.usedIndexes;
      if (showEffects && colorList.isNotEmpty && usedIndexes.isNotEmpty) {
        final int width = colorList.width;
        final int height = colorList.height;
        final double near = 10.0;
        final vmath.Matrix4 viewModel = view;

        for (final int index in usedIndexes) {
          final int x = index % width;
          final int y = (index ~/ width) % height;
          final int z = index ~/ (width * height);

          final Color baseColor = colorList.getColor(x, y, z);

          if (baseColor.a == 0) continue;

          final vmath.Vector3 voxelCenter = vmath.Vector3(x.toDouble(), y.toDouble(), z.toDouble());

          final vmath.Vector4 viewSpace = viewModel.transform(
            vmath.Vector4(voxelCenter.x, voxelCenter.y, voxelCenter.z, 1.0),
          );

          if (viewSpace.z > -near) continue;

          final vmath.Vector4 transformed = projection.transform(viewSpace);
          final double w = transformed.w != 0 ? transformed.w : 1.0;
          final double sx = (transformed.x / w) * size.width / 2 + center.dx;
          final double sy = (-transformed.y / w) * size.height / 2 + center.dy;

          final vmath.Vector4 refView = viewModel.transform(
            vmath.Vector4(voxelCenter.x + 1.0, voxelCenter.y, voxelCenter.z, 1.0),
          );
          if (refView.z > -near) continue;
          final vmath.Vector4 ref = projection.transform(refView);
          final double w2 = ref.w != 0 ? ref.w : 1.0;
          final double sx2 = (ref.x / w2) * size.width / 2 + center.dx;

          final double radius = max((sx2 - sx).abs(), 3.0);

          final Paint paint = Paint()
            ..color = baseColor.withAlpha(76)
            ..style = PaintingStyle.fill;

          canvas.drawCircle(Offset(sx, sy), radius, paint);
        }
      }
    }
  }

  void _drawPlane(
    Canvas canvas,
    Size size,
    Offset center,
    vmath.Matrix4 view,
    vmath.Matrix4 projection, {
    required String axis,
    required Color color,
  }) {
    final EffectBloc effectBloc = GetIt.instance.get();
    final vmath.Vector3 effectsSize = effectBloc.state.effectGridData.size;

    final List<vmath.Vector3> corners = switch (axis) {
      'xy' => <vmath.Vector3>[
          vmath.Vector3(0, 0, 0),
          vmath.Vector3(effectsSize.x, 0, 0),
          vmath.Vector3(effectsSize.x, effectsSize.y, 0),
          vmath.Vector3(0, effectsSize.y, 0),
        ],
      'yz' => <vmath.Vector3>[
          vmath.Vector3(0, 0, effectsSize.z),
          vmath.Vector3(0, effectsSize.y, effectsSize.z),
          vmath.Vector3(0, effectsSize.y, 0),
          vmath.Vector3(0, 0, 0),
        ],
      'xz' => <vmath.Vector3>[
          vmath.Vector3(0, 0, effectsSize.z),
          vmath.Vector3(effectsSize.x, 0, effectsSize.z),
          vmath.Vector3(effectsSize.x, 0, 0),
          vmath.Vector3(0, 0, 0),
        ],
      _ => <vmath.Vector3>[],
    };

    final vmath.Matrix4 viewModel = view;
    final List<vmath.Vector4> viewCorners =
        corners.map((vmath.Vector3 v) => viewModel.transform(vmath.Vector4(v.x, v.y, v.z, 1.0))).toList();
    final List<vmath.Vector4> clipped = _clipFaceAgainstNearPlane(viewCorners, 10.0);
    if (clipped.length < 3) return;

    final List<Offset> projected = clipped.map((vmath.Vector4 v) {
      final vmath.Vector4 p = projection.transform(v);
      final double w = p.w != 0 ? p.w : 1.0;
      return Offset((p.x / w) * size.width / 2 + center.dx, (-p.y / w) * size.height / 2 + center.dy);
    }).toList();

    canvas.drawPath(
        Path()..addPolygon(projected, true),
        Paint()
          ..color = color
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
