import 'package:flutter/material.dart';
import 'package:rgb_app/models/colors_property.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/models/vector_property.dart';

class PropertyFactory {
  static T getProperty<T>(Map<String, Object?> json) {
    final String type = json['type'] as String? ?? '';
    switch (type) {
      case 'NumericProperty':
        return NumericProperty(
          value: json['value'] as double,
          name: json['name'] as String,
          min: json['min'] as double,
          max: json['max'] as double,
        ) as T;
      case 'VectorProperty':
        final Map<String, Object> value = Map<String, Object>.from(json['value'] as Map<String, Object?>);
        return VectorProperty(
          value: Vector.fromJson(value),
          name: json['name'] as String,
        ) as T;
      case 'OptionProperty':
        final List<Map<String, Object?>> value = List<Map<String, Object?>>.from(json['value'] as List<Object?>);
        return OptionProperty(
          value: value.map(Option.fromJson).toSet(),
          name: json['name'] as String,
        ) as T;
      case 'ColorsProperty':
        final List<int> value = json['value'] as List<int>;
        return ColorsProperty(
          value: value.map(Color.new).toList(),
          name: json['name'] as String,
        ) as T;
      default:
        throw Exception('Unsupported property type: $type');
    }
  }
}
