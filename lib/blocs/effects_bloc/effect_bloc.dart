import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/models/effect_grid_data.dart';

class EffectBloc extends HydratedBloc<EffectEvent, EffectState> {
  EffectBloc()
      : super(
          EffectState(
            effectGridData: EffectGridData(
              sizeX: 20,
              sizeY: 20,
            ),
          ),
        ) {
    on<SetGridSizeEvent>(_onSetGridSizeEvent);
  }

  @override
  EffectState fromJson(Map<String, dynamic> json) {
    return EffectState(
      effectGridData: EffectGridData.fromJson(
        json['effectGridData'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  Map<String, dynamic> toJson(EffectState state) {
    return {
      'effectGridData': state.effectGridData,
    };
  }

  Future<void> _onSetGridSizeEvent(
      SetGridSizeEvent event, Emitter<EffectState> emit) async {
    final EffectState newState = state.copyWith(
      effectGridData: event.effectGridData,
    );
    emit(newState);
  }
}
