import 'package:flutter/material.dart';

class DraggablePositionedBorder extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;

  const DraggablePositionedBorder({
    required this.width,
    required this.height,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 2,
          ),
        ),
        child: child,
      ),
    );
  }
}
