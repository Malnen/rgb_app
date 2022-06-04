import 'package:equatable/equatable.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

abstract class EffectEvent extends Equatable {}

class SetGridSizeEvent extends EffectEvent {
  final EffectGridData effectGridData;

  SetGridSizeEvent({
    required this.effectGridData,
  });

  @override
  List<Object> get props => <Object>[
        effectGridData,
      ];
}
