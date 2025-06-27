import 'package:flutter/material.dart';

class DraggableThumb extends StatelessWidget {
  final double size;
  final Color color;

  const DraggableThumb({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 2,
        ),
      ),
    );
  }
}
