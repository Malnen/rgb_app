import 'package:flutter/material.dart';
import 'package:rgb_app/enums/draggable_center.dart';
import 'package:rgb_app/models/vector.dart';

class DraggablePositioned extends StatefulWidget {
  final double width;
  final double height;
  final double fullWidth;
  final double fullHeight;
  final double sizeBase;
  final Widget child;
  final void Function(double, double) updateOffset;
  final bool snapOnPanEnd;
  final DraggableCenter draggableCenter;
  final Vector? initialPosition;
  final double padding;
  final Vector? forcePosition;
  final bool lockY;

  const DraggablePositioned({
    required this.width,
    required this.height,
    required this.fullWidth,
    required this.fullHeight,
    required this.sizeBase,
    required this.child,
    required this.updateOffset,
    this.snapOnPanEnd = false,
    this.draggableCenter = DraggableCenter.topLeft,
    this.initialPosition,
    this.forcePosition,
    this.padding = 0,
    this.lockY = false,
  });

  @override
  State<DraggablePositioned> createState() => _DraggablePositionedState();
}

class _DraggablePositionedState extends State<DraggablePositioned> {
  double left = 0;
  double top = 0;
  double offsetX = 0;
  double offsetY = 0;

  double get height => widget.height;

  double get width => widget.width;

  double get fullHeight => widget.fullHeight;

  double get fullWidth => widget.fullWidth;

  double get padding => widget.padding;

  bool get snapOnPanEnd => widget.snapOnPanEnd;

  bool get lockY => widget.lockY;

  @override
  void initState() {
    super.initState();
    setInitialPosition();
  }

  void setInitialPosition() {
    if (widget.initialPosition != null) {
      left = widget.initialPosition!.x;
      top = widget.initialPosition!.y;
    } else {
      left = fullWidth / 2 - width / 2;
      top = fullHeight / 2 - height / 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Vector position = getCorrectPosition();
    left = position.x;
    top = position.y;

    return Positioned(
      left: position.x + padding,
      top: position.y + padding,
      child: GestureDetector(
        onPanUpdate: onPanUpdate,
        onPanEnd: snapOnPanEnd ? onPanEnd : null,
        child: widget.child,
      ),
    );
  }

  Vector getCorrectPosition() {
    final Vector? forcePosition = widget.forcePosition;
    if (forcePosition != null) {
      if (lockY) {
        return forcePosition.copyWith(
          y: getLockedY(),
        );
      }

      return forcePosition.withPadding(-padding);
    }

    return Vector(
      x: left,
      y: top,
    );
  }

  void onPanUpdate(DragUpdateDetails details) {
    left = getLeft(details);
    top = getTop(details);
    offsetX = getOffset(left, width);
    offsetY = getOffset(top, height);
    widget.updateOffset(
      offsetX,
      offsetY,
    );
    setState(() {});
  }

  void onPanEnd(DragEndDetails details) {
    left = offsetX * widget.sizeBase;
    top = offsetY * widget.sizeBase;
    setState(() {});
  }

  double getLeft(DragUpdateDetails details) {
    final Offset delta = details.delta;
    final double dx = delta.dx;
    final double newLeft = left + dx;
    switch (widget.draggableCenter) {
      case DraggableCenter.topLeft:
        return getTopLeftLeft(newLeft);
      case DraggableCenter.center:
        return getCenterLeft(newLeft);
    }
  }

  double getTopLeftLeft(double newLeft) {
    if (newLeft < 0) {
      return 0;
    } else if (newLeft + width > fullWidth) {
      return fullWidth - width;
    }

    return newLeft;
  }

  double getCenterLeft(double newLeft) {
    final double halfOfWidth = width / 2;
    if (newLeft < -halfOfWidth) {
      return -halfOfWidth;
    } else if (newLeft + halfOfWidth > fullWidth) {
      return fullWidth - halfOfWidth;
    }

    return newLeft;
  }

  double getTop(DragUpdateDetails details) {
    if (lockY) {
      return getLockedY();
    }

    final Offset delta = details.delta;
    final double dy = delta.dy;
    final double newTop = top + dy;
    switch (widget.draggableCenter) {
      case DraggableCenter.topLeft:
        return getTopLeftTop(newTop);
      case DraggableCenter.center:
        return getCenterTop(newTop);
    }
  }

  double getLockedY() {
    return fullHeight / 2 - height / 2;
  }

  double getTopLeftTop(double newTop) {
    if (newTop < 0) {
      return 0;
    } else if (newTop + height > fullHeight) {
      return fullHeight - height;
    }

    return newTop;
  }

  double getCenterTop(double newTop) {
    final double halfOfHeight = height / 2;
    if (newTop < -halfOfHeight) {
      return -halfOfHeight;
    } else if (newTop + halfOfHeight > fullHeight) {
      return fullHeight - halfOfHeight;
    }

    return newTop;
  }

  double getOffset(double value, double dimensionValue) {
    final double dividedValue = getDividedValue(value);
    switch (widget.draggableCenter) {
      case DraggableCenter.topLeft:
        return dividedValue;
      case DraggableCenter.center:
        return dividedValue + dimensionValue / 2;
    }
  }

  double getDividedValue(double value) {
    if (snapOnPanEnd) {
      return (value ~/ widget.sizeBase).toDouble();
    }

    return value / widget.sizeBase;
  }
}
