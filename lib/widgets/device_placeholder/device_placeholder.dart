import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/device_placeholder_data.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_positioned.dart';
import 'package:vector_math/vector_math.dart' as vmath;

class DevicePlaceholder extends HookWidget {
  final double fullHeight;
  final double fullWidth;
  final DevicePlaceholderData devicePlaceholderData;
  final double sizeBase;
  final void Function(double newOffsetX, double newOffsetZ) onUpdateOffset;
  final ValueNotifier<DeviceData> dataNotifier;

  const DevicePlaceholder({
    required this.fullHeight,
    required this.fullWidth,
    required this.devicePlaceholderData,
    required this.sizeBase,
    required this.onUpdateOffset,
    required this.dataNotifier,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> forcePosition = useValueNotifier(true);
    useListenable(dataNotifier);
    final vmath.Vector3 size = devicePlaceholderData.size;
    final vmath.Vector3 scale = dataNotifier.value.scale;
    final double width = sizeBase * size.x * scale.x;
    final double height = sizeBase * size.z * scale.z;
    final int offsetX = dataNotifier.value.offset.x.toInt();
    final int offsetZ = dataNotifier.value.offset.z.toInt();
    final Vector currentPosition = Vector(
      x: offsetX * sizeBase,
      y: offsetZ * sizeBase,
    );

    void updateOffset(double newOffsetX, double newOffsetZ) {
      final int intX = newOffsetX.toInt();
      final int intZ = newOffsetZ.toInt();
      if (intX != offsetX || intZ != offsetZ) {
        onUpdateOffset(newOffsetX, newOffsetZ);
      }
    }

    return DraggablePositioned(
      width: width,
      height: height,
      fullWidth: fullWidth,
      fullHeight: fullHeight,
      sizeBase: sizeBase,
      snapOnPanEnd: true,
      onPanStart: () => forcePosition.value = false,
      onPanEnd: () => forcePosition.value = true,
      updateOffset: updateOffset,
      rotation: dataNotifier.value.rotation,
      forcePosition: forcePosition.value ? currentPosition : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          color: Colors.black.withAlpha(200),
        ),
      ),
    );
  }
}
