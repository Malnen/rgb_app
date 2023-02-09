import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as image;
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_cubit.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_state.dart';
import 'package:rgb_app/enums/color_picker_update_source.dart';
import 'package:rgb_app/enums/draggable_center.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/utils/assets_loader.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_positioned.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_positioned_border.dart';
import 'package:rgb_app/widgets/draggable_positioned/draggable_thumb.dart';

class HuePicker extends StatefulWidget {
  @override
  State<HuePicker> createState() => _HuePickerState();
}

class _HuePickerState extends State<HuePicker> {
  final double sizeX = 150;
  final double sizeY = 10;
  final double thumbSize = 20;
  final double padding = 10;

  late File imageFile;
  late image.Image? decodedImage;
  late ColorPickerCubit colorPickerCubit;

  Color? currentColor;

  @override
  void initState() {
    super.initState();
    colorPickerCubit = context.read();
    imageFile = File(AssetsLoader.getAssetPath('colorPicker.png'));
    setBytes();
  }

  Future<void> setBytes() async {
    final Uint8List bytes = await imageFile.readAsBytes();
    decodedImage = image.decodeImage(bytes);
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
            child: Image.file(
              imageFile,
              fit: BoxFit.fill,
            ),
          ),
          DraggablePositioned(
            width: thumbSize,
            height: thumbSize,
            lockY: true,
            padding: padding,
            fullWidth: sizeX,
            fullHeight: sizeY,
            sizeBase: 1,
            snapOnPanEnd: false,
            draggableCenter: DraggableCenter.center,
            forcePosition: getForcePosition(state),
            child: DraggableThumb(
              color: color,
              size: thumbSize,
            ),
            updateOffset: (double x, _) => updateOffset(x),
          )
        ],
      ),
    );
  }

  Vector? getForcePosition(ColorPickerState state) {
    switch (state.source) {
      case ColorPickerUpdateSource.textField:
        return Vector(
          x: getUpdatedLeft(state),
          y: sizeY / 2 + 10,
        );
      default:
        return null;
    }
  }

  double getUpdatedLeft(ColorPickerState state) {
    final HSVColor hsvColor = HSVColor.fromColor(state.color);
    final double hue = hsvColor.hue;

    return mapValue(
      value: hue,
      oldMax: 360,
      newMax: sizeX.toInt(),
    );
  }

  void updateOffset(double x) {
    if (decodedImage != null) {
      setCurrentColor(x);
    }
  }

  void setCurrentColor(double x) {
    final double roundedX = mapValue(
      value: x,
      oldMax: sizeX.toInt(),
      newMax: 360,
    );
    final ColorPickerState currentState = colorPickerCubit.state;
    final ColorPickerState state = currentState.withHue(
      hue: roundedX,
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
