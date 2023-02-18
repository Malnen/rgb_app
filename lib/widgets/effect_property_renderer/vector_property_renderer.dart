import 'package:flutter/material.dart';
import 'package:rgb_app/enums/draggable_center.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/models/vector_property.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_positioned.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_positioned_border.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_thumb.dart';

class VectorPropertyRenderer extends StatefulWidget {
  final VectorProperty property;

  const VectorPropertyRenderer({required this.property});

  @override
  State<VectorPropertyRenderer> createState() => _VectorPropertyRendererState();
}

class _VectorPropertyRendererState extends State<VectorPropertyRenderer> {
  late Vector initialPosition;

  final double size = 100;
  final double thumbSize = 20;

  VectorProperty get property => widget.property;

  @override
  void initState() {
    super.initState();
    initialPosition = Vector(
      x: property.value.x * size - thumbSize / 2,
      y: property.value.y * size - thumbSize / 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: SizedBox(
        width: size + thumbSize,
        height: size + thumbSize,
        child: Stack(
          children: <Widget>[
            DraggablePositionedBorder(
              width: size,
              height: size,
            ),
            DraggablePositioned(
              width: thumbSize,
              height: thumbSize,
              fullWidth: size,
              fullHeight: size,
              sizeBase: 1,
              padding: 10,
              draggableCenter: DraggableCenter.center,
              updateOffset: updateOffset,
              initialPosition: initialPosition,
              moveOnTap: true,
              child: DraggableThumb(
                color: Colors.orange,
                size: thumbSize,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateOffset(double offsetX, double offsetY) {
    final double x = offsetX / size;
    final double y = offsetY / size;
    final Vector vector = Vector(x: x, y: y);
    onChanged(vector);
  }

  void onChanged(Vector updatedValue) {
    setState(() {
      property.value = updatedValue;
      property.onChange(updatedValue);
    });
  }
}
