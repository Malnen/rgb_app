import 'package:flutter/material.dart';
import 'package:rgb_app/models/colors_property.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/models/vector_property.dart';

class PropertyFactory {
  static Property<Object> getProperty(Map<String, dynamic> json) {
    final String type = json['type'] as String? ?? '';
    switch (type) {
      case 'NumericProperty':
        return NumericProperty(
          value: json['value'] as double,
          name: json['name'] as String,
          min: json['min'] as double,
          max: json['max'] as double,
        );
      case 'VectorProperty':
        final Map<String, Object> value = Map<String, Object>.from(json['value'] as Map<String, dynamic>);
        return VectorProperty(
          value: Vector.fromJson(value),
          name: json['name'] as String,
        );
      case 'OptionProperty':
        final List<Map<String, Object?>> value = List<Map<String, Object?>>.from(json['value'] as List<dynamic>);
        return OptionProperty(
          value: value.map(Option.fromJson).toSet(),
          name: json['name'] as String,
        );
      case 'ColorsProperty':
        final List<int> value = json['value'] as List<int>;
        return ColorsProperty(
          value: value.map(Color.new).toList(),
          name: json['name'] as String,
        );
      default:
        throw Exception('Unsupported property type: $type');
    }
  }
}
