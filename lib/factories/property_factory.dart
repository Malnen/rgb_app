import 'package:flutter/material.dart';
import 'package:rgb_app/models/color_list_property.dart';
import 'package:rgb_app/models/color_property.dart' as color;
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
          initialValue: json['value'] as double,
          name: json['name'] as String,
          min: json['min'] as double,
          max: json['max'] as double,
          debugArtificialValue: json['debugArtificialValue'] as bool,
        ) as T;
      case 'VectorProperty':
        final Map<String, Object> value = Map<String, Object>.from(json['value'] as Map<String, Object?>);
        return VectorProperty(
          initialValue: Vector.fromJson(value),
          name: json['name'] as String,
        ) as T;
      case 'OptionProperty':
        final List<Map<String, Object?>> value = List<Map<String, Object?>>.from(json['value'] as List<Object?>);
        return OptionProperty(
          initialValue: value.map(Option.fromJson).toSet(),
          name: json['name'] as String,
        ) as T;
      case 'ColorListProperty':
        final List<int> value = json['value'] as List<int>;
        return ColorListProperty(
          initialValue: value.map(Color.new).toList(),
          name: json['name'] as String,
        ) as T;
      case 'ColorProperty':
        final int value = json['value'] as int;
        return color.ColorProperty(
          initialValue: Color(value),
          name: json['name'] as String,
        ) as T;
      default:
        throw Exception('Unsupported property type: $type');
    }
  }
}
