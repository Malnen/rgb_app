import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';

class EffectGridCell extends StatefulWidget {
  final int x;
  final int y;
  final EffectBloc bloc;
  final StreamController<Object> rebuildNotifier;
  final double size;
  final double margin;

  const EffectGridCell({
    required this.x,
    required this.y,
    required this.bloc,
    required this.rebuildNotifier,
    required this.size,
    required this.margin,
  });

  @override
  State<EffectGridCell> createState() => _EffectGridCellState();
}

class _EffectGridCellState extends State<EffectGridCell> {
  late StreamSubscription<Object> subscription;

  @override
  void initState() {
    super.initState();
    subscription = widget.rebuildNotifier.stream.listen(onRebuild);
  }

  @override
  Widget build(final BuildContext context) {
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

  void onRebuild(final Object _) {
    setState(() {});
  }

  Color getColor() {
    try {
      return widget.bloc.colors[widget.y][widget.x];
    } catch (e) {
      print(widget.x.toString() + ', ' + widget.y.toString() + ' out of range');
      return Colors.black;
    }
  }
}
