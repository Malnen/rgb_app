import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';

abstract class Effect {
  final EffectBloc effectBloc;

  Effect() : effectBloc = GetIt.instance.get();

  void update();

  String get className => runtimeType.toString();

  Map<String, dynamic> getData();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'className': className,
    };
    final Map<String, dynamic> data = getData();
    json.addAll(data);

    return json;
  }
}
