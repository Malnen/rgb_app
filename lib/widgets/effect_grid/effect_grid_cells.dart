import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/widgets/effect_grid/effect_grid_cell.dart';

class EffectGridCells extends StatelessWidget {
  final double cellMargin;
  final double cellSize;

  const EffectGridCells({
    required this.cellMargin,
    required this.cellSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EffectBloc, EffectState>(
      builder: (_, EffectState state) => Column(
        children: <Widget>[
          ...List<Widget>.generate(
            state.effectGridData.sizeZ,
            (int zIndex) => Row(
              children: <Widget>[
                ...List<Widget>.generate(
                  state.effectGridData.sizeX,
                  (int xIndex) => EffectGridCell(
                    margin: cellMargin,
                    size: cellSize,
                    x: xIndex,
                    y: zIndex,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
