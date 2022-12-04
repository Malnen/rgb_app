import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';

class EffectGridCell extends StatelessWidget {
  final int x;
  final int y;
  final EffectBloc bloc;

  const EffectGridCell({
    required this.x,
    required this.y,
    required this.bloc,
  });

  @override
  Widget build(final BuildContext context) {
    final Color color = getColor();
    return Container(
      color: color,
      width: 20,
      height: 20,
      margin: EdgeInsets.all(2),
    );
  }

  Color getColor() {
    try {
      return bloc.colors[y][x];
    } catch (e) {
      print(x.toString() + ', ' + y.toString() + ' out of range');
      return Colors.black;
    }
  }
}
