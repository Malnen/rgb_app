import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../models/effect_grid_data.dart';

class EffectState extends Equatable {
  final Key key;
  final EffectGridData effectGridData;
  final bool forceUpdate;

  EffectState({
    required this.effectGridData,
    required this.forceUpdate,
  })  : key = UniqueKey();

  @override
  List<Object> get props => <Object>[
        effectGridData,
        forceUpdate,
        key,
      ];

  EffectState copyWith({
    EffectGridData? effectGridData,
    bool? forceUpdate,
  }) {
    return EffectState(
      effectGridData: effectGridData ?? this.effectGridData,
      forceUpdate: forceUpdate ?? false,
    );
  }

  bool hasEffectGridDataSizeOrMinChanged(EffectState state) {
    final EffectGridData effectGridData = state.effectGridData;
    final bool hasDifferentSizeX =
        effectGridData.sizeX != this.effectGridData.sizeX;
    final bool hasDifferentSizeY =
        effectGridData.sizeY != this.effectGridData.sizeY;
    final bool hasDifferentMinX =
        effectGridData.minSizeX != this.effectGridData.minSizeX;
    final bool hasDifferentMinY =
        effectGridData.minSizeY != this.effectGridData.minSizeY;
    return hasDifferentSizeX ||
        hasDifferentSizeY ||
        hasDifferentMinX ||
        hasDifferentMinY;
  }
}
