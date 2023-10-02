import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';

class EffectGridCell extends StatefulWidget {
  final int x;
  final int y;
  final StreamController<Object> rebuildNotifier;
  final double size;
  final double margin;

  const EffectGridCell({
    required this.x,
    required this.y,
    required this.rebuildNotifier,
    required this.size,
    required this.margin,
  });

  @override
  State<EffectGridCell> createState() => _EffectGridCellState();
}

class _EffectGridCellState extends State<EffectGridCell> {
  late StreamSubscription<Object> subscription;
  late EffectBloc effectBloc;
  late EffectsColorsCubit effectsColorsCubit;

  @override
  void initState() {
    super.initState();
    effectBloc = GetIt.instance.get();
    effectsColorsCubit = GetIt.instance.get();
    subscription = widget.rebuildNotifier.stream.listen(onRebuild);
  }

  @override
  Widget build(BuildContext context) {
    final Color color = getColor();
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

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  void onRebuild(Object _) {
    setState(() {});
  }

  Color getColor() {
    try {
      return effectsColorsCubit.colors[widget.y][widget.x];
    } catch (e) {
      print(widget.x.toString() + ', ' + widget.y.toString() + ' out of range');
      return Colors.black;
    }
  }
}
