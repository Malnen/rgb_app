import 'package:flutter/material.dart';
import 'package:rgb_app/enums/draggable_center.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/models/vector_property.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_positioned.dart';

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
      x: property.value.x * size,
      y: property.value.y * size,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size + thumbSize,
      height: size + thumbSize,
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
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
            initialPosition: property.value,
            child: Container(
              width: thumbSize,
              height: thumbSize,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void updateOffset(int offsetX, int offsetY) {
    final double x = offsetX / size;
    final double y = offsetY / size;
    final Vector vector = Vector(x: x, y: y);
    onChanged(vector);
  }

  void onChanged(Vector updatedValue) {
    setState(() {
      property.value = updatedValue;
      property.onChange(updatedValue);
      print(updatedValue);
    });
  }
}
