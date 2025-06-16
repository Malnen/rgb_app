import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:vector_math/vector_math.dart' as vmath;

class ViewPainter3D extends CustomPainter {
  final List<DeviceInterface> devices;
  final double rotationX;
  final double rotationY;
  final double zoomFactor;

  ViewPainter3D({
    required this.devices,
    required this.rotationX,
    required this.rotationY,
    required this.zoomFactor,
  });

  final List<vmath.Vector3> baseCube = <vmath.Vector3>[
    vmath.Vector3(0, 0, 0),
    vmath.Vector3(1, 0, 0),
    vmath.Vector3(1, 1, 0),
    vmath.Vector3(0, 1, 0),
    vmath.Vector3(0, 0, 1),
    vmath.Vector3(1, 0, 1),
    vmath.Vector3(1, 1, 1),
    vmath.Vector3(0, 1, 1),
  ];

  final List<List<int>> edges = <List<int>>[
    <int>[0, 1],
    <int>[1, 2],
    <int>[2, 3],
    <int>[3, 0],
    <int>[4, 5],
    <int>[5, 6],
    <int>[6, 7],
    <int>[7, 4],
    <int>[0, 4],
    <int>[1, 5],
    <int>[2, 6],
    <int>[3, 7],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final double fovY = vmath.radians(60);
    final double aspect = size.width / size.height;
    final double near = 1.0;
    final double far = 1000.0;
    final double f = 1.0 / tan(fovY / 2);

    final vmath.Matrix4 projection = vmath.Matrix4.zero()
      ..setEntry(0, 0, f / aspect)
      ..setEntry(1, 1, f)
      ..setEntry(2, 2, (far + near) / (near - far))
      ..setEntry(2, 3, (2 * far * near) / (near - far))
      ..setEntry(3, 2, -1.0);

    final vmath.Matrix4 view = (vmath.Matrix4.identity()
      ..translate(0.0, 0.0, -200.0 * (1 / zoomFactor))
      ..rotateX(rotationX)
      ..rotateY(rotationY)
      ..translate(0.0, -100.0, 0.0));

    _drawPlane(canvas, size, center, view, projection, axis: 'xy', color: Colors.grey.withAlpha(40));
    _drawPlane(canvas, size, center, view, projection, axis: 'yz', color: Colors.blue.withAlpha(20));
    _drawPlane(canvas, size, center, view, projection, axis: 'xz', color: Colors.green.withAlpha(20));

    for (final DeviceInterface device in devices) {
      final vmath.Vector3 offset = device.deviceData.offset;
      final vmath.Vector3 sizeVec = device.getSize();

      final vmath.Matrix4 model = (vmath.Matrix4.identity()
        ..translate(offset.x, offset.y, offset.z)
        ..scale(sizeVec.x, sizeVec.y, sizeVec.z));

      final vmath.Matrix4 mvp = (projection * view * model) as vmath.Matrix4;

      final List<Offset> projected = baseCube.map((vmath.Vector3 vertex) {
        final vmath.Vector4 transformed = mvp.transform(vmath.Vector4(vertex.x, vertex.y, vertex.z, 1));
        final double w = transformed.w != 0 ? transformed.w : 1.0;
        return Offset(
          (transformed.x / w) * size.width / 2 + center.dx,
          (-transformed.y / w) * size.height / 2 + center.dy,
        );
      }).toList();

      final Paint paint = Paint()
        ..color = Colors.white60
        ..strokeWidth = 2.0;

      for (final List<int> edge in edges) {
        canvas.drawLine(projected[edge[0]], projected[edge[1]], paint);
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
    late List<vmath.Vector3> corners;

    switch (axis) {
      case 'xy':
        corners = <vmath.Vector3>[
          vmath.Vector3(0, 0, 0),
          vmath.Vector3(100, 0, 0),
          vmath.Vector3(100, 100, 0),
          vmath.Vector3(0, 100, 0),
        ];
        break;
      case 'yz':
        corners = <vmath.Vector3>[
          vmath.Vector3(0, 0, 0),
          vmath.Vector3(0, 100, 0),
          vmath.Vector3(0, 100, -100),
          vmath.Vector3(0, 0, -100),
        ];
        break;
      case 'xz':
        corners = <vmath.Vector3>[
          vmath.Vector3(0, 0, 0),
          vmath.Vector3(100, 0, 0),
          vmath.Vector3(100, 0, -100),
          vmath.Vector3(0, 0, -100),
        ];
        break;
    }

    final vmath.Matrix4 model = vmath.Matrix4.identity();
    final vmath.Matrix4 mvp = (projection * view * model) as vmath.Matrix4;

    final List<Offset> projected = corners.map((vmath.Vector3 vertex) {
      final vmath.Vector4 transformed = mvp.transform(vmath.Vector4(vertex.x, vertex.y, vertex.z, 1));
      final double w = transformed.w != 0 ? transformed.w : 1.0;
      return Offset(
        (transformed.x / w) * size.width / 2 + center.dx,
        (-transformed.y / w) * size.height / 2 + center.dy,
      );
    }).toList();

    final Path path = Path()..addPolygon(projected, true);
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
