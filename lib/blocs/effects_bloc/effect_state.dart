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
  }) : key = UniqueKey();

  @override
  List<Object> get props => <Object>[
        effectGridData,
        forceUpdate,
        key,
      ];

  factory EffectState.initial() {
    return EffectState(
      effectGridData: EffectGridData.initial(),
      forceUpdate: false,
    );
  }

  EffectState copyWith({
    EffectGridData? effectGridData,
    bool? forceUpdate,
  }) {
    return EffectState(
      effectGridData: effectGridData ?? this.effectGridData,
      forceUpdate: forceUpdate ?? false,
    );
  }
}
