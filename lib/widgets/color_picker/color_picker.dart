import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as image;
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_cubit.dart';
import 'package:rgb_app/cubits/color_picker_cubit/color_picker_state.dart';
import 'package:rgb_app/enums/color_picker_update_source.dart';
import 'package:rgb_app/enums/draggable_center.dart';
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
    imageFile = File('assets/colorPicker.png');
    setBytes();
  }

  Future<void> setBytes() async {
    final Uint8List bytes = await imageFile.readAsBytes();
    decodedImage = image.decodeImage(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final Color color = context.select<ColorPickerCubit, Color>(
      (ColorPickerCubit cubit) => cubit.state.color,
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
            child: Container(
              width: thumbSize,
              height: thumbSize,
              decoration: BoxDecoration(
                color: color,
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
      colorPickerCubit.setColor(state);
    }
  }

  int roundValue(double value, int size) {
    return (value / 100 * (size - 1)).toInt();
  }
}
