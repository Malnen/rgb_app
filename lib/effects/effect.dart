import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';

abstract class Effect {
  final EffectBloc effectBloc;

  Effect() : effectBloc = GetIt.instance.get();

  void update();
}
