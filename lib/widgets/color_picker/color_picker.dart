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

class ColorPicker extends StatefulWidget {
  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final double size = 100;
  final double thumbSize = 20;

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

    return SizedBox(
      width: size + thumbSize,
      height: size + thumbSize,
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              child: Image.file(
                imageFile,
                width: size,
                height: size,
              ),
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
            padding: 10,
            fullWidth: size,
            fullHeight: size,
            sizeBase: 1,
            snapOnPanEnd: false,
            draggableCenter: DraggableCenter.center,
            forcePosition: state.source == ColorPickerUpdateSource.textField ? getUpdatedPosition(state) : null,
            child: Container(
              width: thumbSize,
              height: thumbSize,
              decoration: BoxDecoration(
                color: state.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
            updateOffset: updateOffset,
          )
        ],
      ),
    );
  }

  Vector getUpdatedPosition(ColorPickerState state) {
    final int height = decodedImage!.height;
    final int width = decodedImage!.width;
    final HSVColor hsvColor = HSVColor.fromColor(state.color);
    final double saturation = hsvColor.saturation;
    final double halfOfHeight = height / 2;
    final double x = hsvColor.hue * width / 360;
    final double value = hsvColor.value;
    final double y =
        saturation < value || saturation == 0 && value != 0 ? saturation * halfOfHeight : height - value * halfOfHeight;
    print(
      Vector(
            x: mapValue(value: x, oldMax: width, newMax: 100),
            y: mapValue(value: y, oldMax: height, newMax: 100),
          ).toString() +
          ' ' +
          hsvColor.toString(),
    );
    return Vector(
      x: mapValue(value: x, oldMax: width, newMax: 100),
      y: mapValue(value: y, oldMax: height, newMax: 100),
    );
  }

  double mapValue({
    required double value,
    required int oldMax,
    required int newMax,
  }) {
    return value * newMax / oldMax;
  }

  void updateOffset(double x, double y) {
    if (decodedImage != null) {
      setCurrentColor(x, y);
    }
  }

  void setCurrentColor(double x, double y) {
    final int roundedX = roundValue(x, decodedImage!.width);
    final int roundedY = roundValue(y, decodedImage!.height);
    final image.Pixel? pixel = decodedImage?.getPixel(roundedX, roundedY);
    if (pixel != null) {
      final Color color = Color.fromARGB(
        255,
        pixel.r.toInt(),
        pixel.g.toInt(),
        pixel.b.toInt(),
      );
      final ColorPickerState state = ColorPickerState(
        color: color,
        source: ColorPickerUpdateSource.colorPicker,
      );
      colorPickerCubit.update(state);
    }
  }

  int roundValue(double value, int size) {
    return (value / 100 * (size - 1)).toInt();
  }
}
