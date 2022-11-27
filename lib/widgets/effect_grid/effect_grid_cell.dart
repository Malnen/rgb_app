import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';

class EffectGridCell extends StatefulWidget {
  final int x;
  final int y;

  const EffectGridCell({
    required this.x,
    required this.y,
  });

  @override
  State<EffectGridCell> createState() => _EffectGridCellState();
}

class _EffectGridCellState extends State<EffectGridCell> {
  late EffectBloc bloc;

  Color color = Colors.black;

  @override
  void initState() {
    super.initState();
    bloc = context.read();
    Timer.periodic(Duration(milliseconds: 25), (timer) {
      setState(() {
        setColor();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: 20,
      height: 20,
      margin: EdgeInsets.all(2),
    );
  }

  void setColor() {
    try {
      color = bloc.colors[widget.y][widget.x];
    } catch (e) {
      print(widget.x.toString() + ', ' + widget.y.toString() + ' out of range');
    }
  }
}
