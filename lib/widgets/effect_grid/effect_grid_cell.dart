import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/models/color_list.dart';
import 'package:rgb_app/utils/tick_provider.dart';
import 'package:rgb_app/utils/type_defs.dart';

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
  late final FutureVoidCallback _onTick;

  @override
  void initState() {
    final TickProvider tickerProvider = GetIt.instance.get();
    _onTick = () async => setState(() {});
    tickerProvider.onTick(_onTick);
    super.initState();
  }

  @override
  void dispose() {
    final TickProvider tickerProvider = GetIt.instance.get();
    tickerProvider.removeOnTick(_onTick);
    super.dispose();
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
    final ColorList colors = cubit.colors;
    if (colors.width > widget.x && colors.height > widget.y) {
      return colors.getColor(widget.x, widget.y);
    }

    return Colors.white;
  }
}
