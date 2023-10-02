import 'package:equatable/equatable.dart';
import 'package:rgb_app/effects/effect.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

abstract class EffectEvent extends Equatable {}

class SetGridSizeEvent extends EffectEvent {
  final EffectGridData effectGridData;

  SetGridSizeEvent({required this.effectGridData});

  @override
  List<Object> get props => <Object>[effectGridData];
}

class AddEffectEvent extends EffectEvent {
  final Effect effect;

  AddEffectEvent({required this.effect});

  @override
  List<Object> get props => <Object>[effect];
}

class RemoveEffectEvent extends EffectEvent {
  final Effect effect;

  RemoveEffectEvent({required this.effect});

  @override
  List<Object> get props => <Object>[effect];
}

class ReorderEffectsEvent extends EffectEvent {
  final int oldIndex;
  final int newIndex;

  ReorderEffectsEvent({
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object> get props => <Object>[
        oldIndex,
        newIndex,
      ];
}

class SelectEffectEvent extends EffectEvent {
  final Effect effect;

  SelectEffectEvent(this.effect);

  @override
  List<Object> get props => <Object>[effect];
}
