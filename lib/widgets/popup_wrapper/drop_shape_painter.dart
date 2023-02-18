import 'package:flutter/material.dart';

class DropShapePainter extends CustomPainter {
  final Color color;
  final Color strokeColor;
  final double strokeWidth;

  DropShapePainter({
    required this.color,
    required this.strokeColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    drawInside(canvas, size);
    drawStroke(canvas, size);
    drawMask(canvas, size);
  }

  void drawInside(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final double width = size.width;
    final double height = size.height;
    final Offset offset = Offset(strokeWidth, strokeWidth);
    drawPath(
      width: width,
      height: height,
      canvas: canvas,
      paint: paint,
      offset: offset,
    );
  }

  void drawStroke(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final double width = size.width + strokeWidth;
    final double height = size.height + strokeWidth;
    drawPath(
      width: width,
      height: height,
      canvas: canvas,
      paint: paint,
    );
  }

  void drawPath({
    required double width,
    required double height,
    required Canvas canvas,
    required Paint paint,
    Offset offset = Offset.zero,
  }) {
    Path path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(0, height * 0.25, width * 0.5, height)
      ..quadraticBezierTo(width * 0.5, height, width * 0.5, height)
      ..quadraticBezierTo(width, height * 0.25, width, 0)
      ..close();
    path = path.shift(offset);

    canvas.drawPath(path, paint);
  }

  void drawMask(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = strokeWidth * 2;

    final double offset = strokeWidth * 0.5;
    final Offset start = Offset(offset, 0);
    final double width = size.width;
    final Offset end = Offset(width + offset, 0);
    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
