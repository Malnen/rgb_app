import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/factories/property_factory.dart';
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

  @mustCallSuper
  void init() {
    for (Property<Object> property in properties) {
      property.addListener(onPropertyChanged);
      property.notify();
    }
  }

  void update();

  void updatePropertiesFromJson(Map<String, Object?> json) {
    for (Property<Object> property in properties) {
      final Property<Object> newProperty = PropertyFactory.getProperty(json, property.idn);
      property.updateProperty(newProperty);
    }
  }

  void dispose() {}

  @protected
  void onPropertyChanged() {
    final EffectPropertyChangedEvent event = EffectPropertyChangedEvent();
    effectBloc.add(event);
  }

  Map<String, Object?> toJson() {
    final Map<String, Object?> json = <String, Object?>{
      'className': effectData.className,
    };
    final Map<String, Object?> data = _getData();
    json.addAll(data);

    return json;
  }

  Map<String, Object?> _getData() {
    return <String, Object?>{
      for (Property<Object> property in properties) property.idn: property.toJson(),
    };
  }
}
