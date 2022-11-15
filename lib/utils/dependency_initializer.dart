import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';

class DependencyInitializer {
  static void init() {
    final GetIt instance = GetIt.instance;
    _initEffectBloc(instance);
  }

  static void _initEffectBloc(GetIt instance) {
    EffectBloc effectBloc = EffectBloc();
    instance.registerSingleton(effectBloc);
  }
}
