import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/models/property.dart';

abstract class Effect {
  final EffectData effectData;

  late EffectBloc effectBloc;

  List<Property<Object>> get properties => <Property<Object>>[];

  Effect(EffectData effectData) : effectData = effectData.getWithNewKey();

  void init() {}

  void setEffectBloc() {
    effectBloc = GetIt.instance.get();
  }

  void update();

  Map<String, Object?> getData();

  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{
      'className': effectData.className,
    };
    final Map<String, Object?> data = getData();
    json.addAll(data);

    return json;
  }
}
