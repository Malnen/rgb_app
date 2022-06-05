import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';

import '../../blocs/effects_bloc/effect_state.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: setColor,
      bloc: bloc,
      child: Container(
        color: color,
        width: 20,
        height: 20,
        margin: EdgeInsets.all(2),
      ),
    );
  }

  void setColor(BuildContext context, EffectState state) {
    try {
      color = bloc.colors[widget.y][widget.x];
      setState(() {});
    } catch (e) {
      print(widget.x.toString() + ', ' + widget.y.toString() + ' out of range');
    }
  }
}
