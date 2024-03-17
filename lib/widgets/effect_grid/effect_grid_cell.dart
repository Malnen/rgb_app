import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/utils/tick_provider.dart';

class EffectGridCell extends StatefulWidget {
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
  State<EffectGridCell> createState() => _EffectGridCellState();
}

class _EffectGridCellState extends State<EffectGridCell> {
  @override
  void initState() {
    final TickProvider tickerProvider = GetIt.instance.get();
    tickerProvider.onTick(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = context.select<EffectsColorsCubit, Color>(_getColor);
    return Container(
      width: widget.size,
      height: widget.size,
      margin: EdgeInsets.all(widget.margin),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(2)),
        color: color,
      ),
    );
  }

  Color _getColor(EffectsColorsCubit cubit) {
    final List<List<Color>> colors = cubit.colors;
    if (colors.length > widget.y && colors.first.length > widget.x) {
      return colors[widget.y][widget.x];
    }

    return Colors.white;
  }
}
