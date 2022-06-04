import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

import '../../blocs/effects_bloc/effect_bloc.dart';
import '../../blocs/effects_bloc/effect_state.dart';

class EffectGridContainer extends StatefulWidget {
  @override
  State<EffectGridContainer> createState() => _EffectGridContainerState();
}

class _EffectGridContainerState extends State<EffectGridContainer> {
  late EffectBloc bloc;
  late EffectGridData effectGridData;

  bool shouldSetState = false;

  @override
  void initState() {
    super.initState();
    bloc = context.read();
    effectGridData = bloc.state.effectGridData;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: listener,
      bloc: bloc,
      child: Column(
        children: <Widget>[
          ...buildRows(),
        ],
      ),
    );
  }

  void listener(BuildContext context, EffectState state) {
    setEffectGridDataIfHasDifferentSize(state);
    if (shouldSetState) {
      shouldSetState = false;
      setState(() {});
    }
  }

  void setEffectGridDataIfHasDifferentSize(EffectState state) {
    final EffectGridData effectGridData = state.effectGridData;
    final bool hasDifferentSizeX =
        effectGridData.sizeX != this.effectGridData.sizeX;
    final bool hasDifferentSizeY =
        effectGridData.sizeY != this.effectGridData.sizeY;
    if (hasDifferentSizeX || hasDifferentSizeY) {
      this.effectGridData = effectGridData;
      shouldSetState = true;
    }
  }

  List<Widget> buildRows() {
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < effectGridData.sizeY; i++) {
      final List<Widget> cells = buildCells();
      final Widget row = Row(
        children: <Widget>[
          ...cells,
        ],
      );
      rows.add(row);
    }

    return rows;
  }

  List<Widget> buildCells() {
    final List<Widget> cells = <Widget>[];
    for (int i = 0; i < effectGridData.sizeX; i++) {
      final Widget cell = Container(
        color: Colors.red,
        width: 20,
        height: 20,
        margin: EdgeInsets.all(2),
      );
      cells.add(cell);
    }

    return cells;
  }
}
