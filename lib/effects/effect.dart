import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/effects/effect_data.dart';

abstract class Effect {
  final EffectData effectData;

  late EffectBloc effectBloc;

  Effect({required this.effectData});

  void setEffectBloc() {
    effectBloc = GetIt.instance.get();
  }

  void update();

  Map<String, dynamic> getData();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{
      'className': effectData.className,
    };
    final Map<String, dynamic> data = getData();
    json.addAll(data);

    return json;
  }
}
