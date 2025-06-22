import 'package:flutter/material.dart';
import 'package:rgb_app/enums/numeric_property_type.dart';
import 'package:rgb_app/models/color_list_property.dart';
import 'package:rgb_app/models/color_property.dart' as color;
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/options_property.dart';
import 'package:rgb_app/models/vector.dart';
import 'package:rgb_app/models/vector_property.dart';

class PropertyFactory {
  static T getProperty<T>(Map<String, Object?> data, String idn) {
    final Map<String, Object?> json = data[idn] as Map<String, Object?>;
    final String type = json['type'] as String? ?? '';
    switch (type) {
      case 'NumericProperty':
        return NumericProperty(
          idn: idn,
          initialValue: json['value'] as double,
          name: json['name'] as String,
          propertyType: NumericPropertyType.values.byName(json['propertyType'] as String),
        ) as T;
      case 'VectorProperty':
        final Map<String, Object> value = Map<String, Object>.from(json['value'] as Map<String, Object?>);
        return VectorProperty(
          idn: idn,
          initialValue: Vector.fromJson(value),
          name: json['name'] as String,
        ) as T;
      case 'OptionProperty':
        final List<Map<String, Object?>> value = List<Map<String, Object?>>.from(json['value'] as List<Object?>);
        return OptionProperty(
          idn: idn,
          initialValue: value.map(Option.fromJson).toSet(),
          name: json['name'] as String,
        ) as T;
      case 'ColorListProperty':
        final List<int> value = json['value'] as List<int>;
        return ColorListProperty(
          idn: idn,
          initialValue: value.map(Color.new).toList(),
          name: json['name'] as String,
        ) as T;
      case 'ColorProperty':
        final int value = json['value'] as int;
        return color.ColorProperty(
          idn: idn,
          initialValue: Color(value),
          name: json['name'] as String,
        ) as T;
      default:
        throw Exception('Unsupported property type: $type');
    }
  }
}
