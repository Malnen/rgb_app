import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/property.dart';

class PropertyFactory {
  static Property<Object> getProperty(final Map<String, dynamic> json) {
    final String type = json['type'] as String? ?? '';
    switch (type) {
      case 'NumericProperty':
        return NumericProperty(
          value: json['value'] as double,
          name: json['name'] as String,
          min: json['min'] as double,
          max: json['max'] as double,
        );
      default:
        throw Exception('Unsupported property type: $type');
    }
  }
}
