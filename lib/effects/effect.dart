import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/models/property.dart';

abstract class Effect {
  final EffectData effectData;

  EffectBloc? _effectBloc;
  EffectsColorsCubit? _effectsColorsCubit;

  Effect(EffectData effectData) : effectData = effectData.getWithNewKey() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
    });
  }

  List<Property<Object>> get properties => <Property<Object>>[];

  EffectBloc get effectBloc {
    _effectBloc ??= GetIt.instance.get();
    return _effectBloc!;
  }

  EffectsColorsCubit get effectsColorsCubit {
    _effectsColorsCubit ??= GetIt.instance.get();
    return _effectsColorsCubit!;
  }

  void init() {}

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
