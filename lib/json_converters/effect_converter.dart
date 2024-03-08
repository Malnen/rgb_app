import 'package:json_annotation/json_annotation.dart';
import 'package:rgb_app/effects/effect.dart';

class EffectConverter implements JsonConverter<Effect, Map<String, Object?>> {
  const EffectConverter();

  @override
  Effect fromJson(Map<String, Object?> json) => Effect.fromJson(json);

  @override
  Map<String, Object?> toJson(Effect object) => object.toJson();
}
