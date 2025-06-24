import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_event.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/effects/effect_data.dart';
import 'package:rgb_app/factories/effect_factory.dart';
import 'package:rgb_app/factories/property_factory.dart';
import 'package:rgb_app/mixins/subscriber.dart';
import 'package:rgb_app/models/color_list.dart';
import 'package:rgb_app/models/property.dart';

abstract class Effect with Subscriber {
  final EffectData effectData;
  EffectBloc? _effectBloc;
  EffectsColorsCubit? _effectsColorsCubit;

  Effect(EffectData effectData) : effectData = EffectData.getWithNewKey(effectData) {
    WidgetsBinding.instance.addPostFrameCallback((_) => init());
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

  ColorList get colors => effectsColorsCubit.colors;

  @mustCallSuper
  void init() {
    for (Property<Object> property in properties) {
      property.addListener(onPropertyChanged);
      property.notify();
      property.enableDebounce();
    }
  }

  void update();

  void updatePropertiesFromJson(Map<String, Object?> json) {
    for (Property<Object> property in properties) {
      final Property<Object> newProperty = PropertyFactory.getProperty(json, property.idn);
      property.updateProperty(newProperty);
    }
  }

  @mustCallSuper
  void dispose() {
    unsubscribe();
  }

  @protected
  void processUsedIndexes(void Function(int x, int y, int z) process) {
    final Set<int> usedIndexes = effectsColorsCubit.state.usedIndexes;
    final int width = colors.width;
    final int height = colors.height;

    for (final int index in usedIndexes) {
      final int z = index ~/ (width * height);
      final int rem = index % (width * height);
      final int y = rem ~/ width;
      final int x = rem % width;
      process(x, y, z);
    }
  }

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

  factory Effect.fromJson(Map<String, Object?> json) => EffectFactory.getEffectFromJson(json);

  Map<String, Object?> _getData() {
    return <String, Object?>{
      for (Property<Object> property in properties) property.idn: property.toJson(),
    };
  }
}
