import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../models/effect_grid_data.dart';

class EffectState extends Equatable {
  final Key key;
  final EffectGridData effectGridData;

  EffectState({
    required this.effectGridData,
  }) : key = UniqueKey();

  @override
  List<Object> get props => <Object>[
        effectGridData,
        key,
      ];

  EffectState copyWith({
    EffectGridData? effectGridData,
  }) {
    return EffectState(
      effectGridData: effectGridData ?? this.effectGridData,
    );
  }
}
