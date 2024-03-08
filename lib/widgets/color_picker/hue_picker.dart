import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_cubit.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_state.dart';
import 'package:rgb_app/enums/color_picker_update_source.dart';
import 'package:rgb_app/enums/draggable_center.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/widgets/color_picker/hue_presenter.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_positioned.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_positioned_border.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_thumb.dart';

class HuePicker extends StatefulWidget {
  @override
  State<HuePicker> createState() => _HuePickerState();
}

class _HuePickerState extends State<HuePicker> {
  final double sizeY = 165;
  final double sizeX = 10;
  final double thumbSize = 20;
  final double padding = 10;

  late ColorPickerCubit colorPickerCubit;

  Color? currentColor;

  @override
  void initState() {
    super.initState();
    colorPickerCubit = context.read();
  }

  @override
  Widget build(BuildContext context) {
    final ColorPickerState state = context.select<ColorPickerCubit, ColorPickerState>(
      (ColorPickerCubit cubit) => cubit.state,
    );
    final HSVColor hsvColor = HSVColor.fromAHSV(1, state.hue, 1, 1);
    final Color color = hsvColor.toColor();

    return SizedBox(
      width: sizeX + thumbSize,
      height: sizeY + thumbSize,
      child: Stack(
        children: <Widget>[
          DraggablePositionedBorder(
            width: sizeX,
            height: sizeY,
            child: HuePresenter(),
          ),
          DraggablePositioned(
            width: thumbSize,
            height: thumbSize,
            lockX: true,
            padding: padding,
            fullWidth: sizeX,
            fullHeight: sizeY,
            sizeBase: 1,
            snapOnPanEnd: false,
            moveOnTap: true,
            draggableCenter: DraggableCenter.center,
            forcePosition: getForcePosition(state),
            child: DraggableThumb(
              color: color,
              size: thumbSize,
            ),
            updateOffset: (_, double y) => updateOffset(y),
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
      x: sizeX / 2 + padding,
      y: getUpdatedTop(state),
    );
  }

  double getUpdatedTop(ColorPickerState state) {
    final HSVColor hsvColor = HSVColor.fromColor(state.color);
    final double hue = hsvColor.hue;

    return mapValue(
      value: hue,
      oldMax: 360,
      newMax: sizeY.toInt(),
    );
  }

  void updateOffset(double y) {
    final double roundedY = mapValue(
      value: y,
      oldMax: sizeY.toInt(),
      newMax: 360,
    );
    final ColorPickerState currentState = colorPickerCubit.state;
    final ColorPickerState state = currentState.withHue(
      hue: roundedY,
      source: ColorPickerUpdateSource.huePicker,
    );
    colorPickerCubit.update(state);
  }

  double mapValue({
    required double value,
    required int oldMax,
    required int newMax,
  }) {
    return value * newMax / oldMax;
  }
}
