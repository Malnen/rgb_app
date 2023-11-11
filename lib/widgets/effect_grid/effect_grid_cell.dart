import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';

class EffectGridCell extends StatelessWidget {
  final int x;
  final int y;
  final double size;
  final double margin;

  const EffectGridCell({
    required this.x,
    required this.y,
    required this.size,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = context.select<EffectsColorsCubit, Color>(_getColor);
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        color: color,
      ),
    );
  }

  Color _getColor(EffectsColorsCubit cubit) {
    final List<List<Color>> colors = cubit.colors;
    if (colors.length > y && colors.first.length > x) {
      return colors[y][x];
    }

    return Colors.white;
  }
}
