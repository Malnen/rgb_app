import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';

abstract class Effect {
  final EffectBloc effectBloc;

  Effect({required this.effectBloc});

  void update();
}
