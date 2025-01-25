import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/json_converters/icon_data_converter.dart';
import 'package:rgb_app/json_converters/unique_key_converter.dart';

part '../generated/effects/effect_data.freezed.dart';
part '../generated/effects/effect_data.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class EffectData with _$EffectData {
  EffectData._();

  factory EffectData({
    required String name,
    required String className,
    @IconDataConverter() required IconData iconData,
    @UniqueKeyConverter() required UniqueKey key,
  }) = _EffectData;

  factory EffectData.withRandomKey({
    required String name,
    required String className,
    required IconData iconData,
  }) =>
      EffectData(
        name: name,
        className: className,
        iconData: iconData,
        key: UniqueKey(),
      );

  factory EffectData.fromJson(Map<String, Object?> json) => _$EffectDataFromJson(json);

  factory EffectData.getWithNewKey(EffectData effectData) => effectData.copyWith(key: UniqueKey());
}
