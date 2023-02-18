import 'package:flutter/material.dart';

class HuePresenter extends StatefulWidget {
  @override
  State<HuePresenter> createState() => _HuePresenterState();
}

class _HuePresenterState extends State<HuePresenter> {
  final int step = 1;
  final int range = 360;

  late List<Color> colors;
  late List<double> stops;

  @override
  void initState() {
    super.initState();
    setColors();
    setStops();
  }

  void setColors() {
    colors = List<Color>.generate(range, getColor);
  }

  Color getColor(int index) {
    final double hue = index.toDouble();
    final HSVColor hsv = HSVColor.fromAHSV(1, hue, 1, 1);

    return hsv.toColor();
  }

  void setStops() {
    stops = List<double>.generate(range, getStop);
  }

  double getStop(int index) {
    final double stop = index.toDouble();
    return stop / range;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          stops: stops,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
