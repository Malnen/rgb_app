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
  final bool moveOnTap;
  final DraggableCenter draggableCenter;
  final Vector? initialPosition;
  final double padding;
  final Vector? forcePosition;
  final bool lockY;
  final bool lockX;

  const DraggablePositioned({
    required this.width,
    required this.height,
    required this.fullWidth,
    required this.fullHeight,
    required this.sizeBase,
    required this.child,
    required this.updateOffset,
    this.snapOnPanEnd = false,
    this.moveOnTap = false,
    this.draggableCenter = DraggableCenter.topLeft,
    this.initialPosition,
    this.forcePosition,
    this.padding = 0,
    this.lockY = false,
    this.lockX = false,
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

  bool get lockX => widget.lockX;

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

    return widget.moveOnTap ? buildWithMoveOnStart(position) : buildNormal(position);
  }

  Widget buildNormal(Vector position) {
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

  Widget buildWithMoveOnStart(Vector position) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: position.x + padding,
          top: position.y + padding,
          child: widget.child,
        ),
        GestureDetector(
          onPanStart: onPanStart,
          onPanUpdate: onPanUpdate,
          onPanEnd: snapOnPanEnd ? onPanEnd : null,
        ),
      ],
    );
  }

  Vector getCorrectPosition() {
    final Vector? forcePosition = widget.forcePosition;
    if (forcePosition != null) {
      return getForcedPosition(forcePosition);
    }

    return Vector(
      x: left,
      y: top,
    );
  }

  Vector getForcedPosition(Vector forcePosition) {
    if (lockY) {
      return forcePosition.copyWith(
        y: getLockedY(),
      );
    }

    if (lockX) {
      return forcePosition.copyWith(
        x: getLockedX(),
      );
    }

    return forcePosition.withPadding(-padding);
  }

  void onPanStart(DragStartDetails details) {
    final Offset localPosition = details.localPosition;
    final double x = localPosition.dx - padding - width / 2;
    final double y = localPosition.dy - padding - height / 2;
    left = getLeft(x);
    top = getTop(y);
    setOffset();
    setState(() {});
  }

  void onPanUpdate(DragUpdateDetails details) {
    final Offset delta = details.delta;
    final double x = delta.dx + left;
    final double y = delta.dy + top;
    left = getLeft(x);
    top = getTop(y);
    setOffset();
    setState(() {});
  }

  void setOffset() {
    offsetX = getOffset(left, width);
    offsetY = getOffset(top, height);
    widget.updateOffset(
      offsetX,
      offsetY,
    );
  }

  void onPanEnd(DragEndDetails details) {
    left = offsetX * widget.sizeBase;
    top = offsetY * widget.sizeBase;
    setState(() {});
  }

  double getLeft(double newLeft) {
    if (lockX) {
      return getLockedX();
    }

    return switch (widget.draggableCenter) {
      DraggableCenter.topLeft => getTopLeftLeft(newLeft),
      DraggableCenter.center => getCenterLeft(newLeft)
    };
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

  double getTop(double newTop) {
    if (lockY) {
      return getLockedY();
    }

    return switch (widget.draggableCenter) {
      DraggableCenter.topLeft => getTopLeftTop(newTop),
      DraggableCenter.center => getCenterTop(newTop)
    };
  }

  double getLockedY() {
    return fullHeight / 2 - height / 2;
  }

  double getLockedX() {
    return fullWidth / 2 - width / 2;
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
    return switch (widget.draggableCenter) {
      DraggableCenter.topLeft => dividedValue,
      DraggableCenter.center => dividedValue + dimensionValue / 2
    };
  }

  double getDividedValue(double value) {
    if (snapOnPanEnd) {
      return (value ~/ widget.sizeBase).toDouble();
    }

    return value / widget.sizeBase;
  }
}
