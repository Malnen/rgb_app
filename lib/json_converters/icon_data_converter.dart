import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class IconDataConverter implements JsonConverter<IconData, int> {
  const IconDataConverter();

  @override
  IconData fromJson(int json) => IconData(json);

  @override
  int toJson(IconData object) => object.codePoint;
}
