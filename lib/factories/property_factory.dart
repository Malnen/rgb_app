import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/options.dart';
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
        final Map<String, Object> value = Map<String, Object>.from(json['value'] as Map<String, dynamic>);
        return OptionProperty(
          value: Options.fromJson(value),
          name: json['name'] as String,
        );
      default:
        throw Exception('Unsupported property type: $type');
    }
  }
}
