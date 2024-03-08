import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class UniqueKeyConverter implements JsonConverter<UniqueKey, String> {
  const UniqueKeyConverter();

  @override
  UniqueKey fromJson(String json) => UniqueKey();

  @override
  String toJson(UniqueKey object) => object.toString();
}
