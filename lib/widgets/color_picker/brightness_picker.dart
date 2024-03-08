import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_cubit.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_state.dart';
import 'package:rgb_app/enums/color_picker_update_source.dart';
import 'package:rgb_app/enums/draggable_center.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/widgets/color_picker/brightness_renderer.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_positioned.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_positioned_border.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_thumb.dart';

class BrightnessPicker extends StatelessWidget {
  final double size = 100;
  final double thumbSize = 20;
  final double padding = 10;

  @override
  Widget build(BuildContext context) {
    final ColorPickerCubit cubit = context.watch<ColorPickerCubit>();
    final ColorPickerState state = cubit.state;
    final HSVColor hsvColor = HSVColor.fromAHSV(1, state.hue, 1, 1);

    return SizedBox(
      width: size + thumbSize,
      height: size + thumbSize,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(
            width: size,
            height: size,
            child: BrightnessRenderer(
              color: hsvColor.toColor(),
            ),
          ),
          DraggablePositionedBorder(
            width: size,
            height: size,
          ),
          DraggablePositioned(
            width: thumbSize,
            height: thumbSize,
            padding: padding,
            fullWidth: size,
            fullHeight: size,
            sizeBase: 1,
            snapOnPanEnd: false,
            moveOnTap: true,
            forcePosition: getForcePosition(state),
            draggableCenter: DraggableCenter.center,
            child: DraggableThumb(
              color: state.color,
              size: thumbSize,
            ),
            updateOffset: (double x, double y) => setCurrentColor(x, y, cubit),
          ),
        ],
      ),
    );
  }

  Vector? getForcePosition(ColorPickerState state) {
    return switch (state.source) {
      ColorPickerUpdateSource.textField => getUpdatedPosition(state),
      ColorPickerUpdateSource.initial => getUpdatedPosition(state),
      _ => null
    };
  }

  Vector getUpdatedPosition(ColorPickerState state) {
    return Vector(
      x: state.saturation * 100,
      y: 100 - state.value * 100,
    );
  }

  void setCurrentColor(double x, double y, ColorPickerCubit cubit) {
    final ColorPickerState currentState = cubit.state;
    final ColorPickerState state = currentState.withBrightness(
      saturation: x / size,
      value: 1 - y / size,
      source: ColorPickerUpdateSource.brightnessPicker,
    );
    cubit.update(state);
  }
}
