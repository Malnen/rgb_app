import 'package:json_annotation/json_annotation.dart';
import 'package:rgb_app/factories/property_factory.dart';
import 'package:rgb_app/models/property.dart';

class PropertyConverter implements JsonConverter<Property<Object>, Map<String, Object?>> {
  const PropertyConverter();

  @override
  Property<Object> fromJson(Map<String, Object?> json) {
    final String idn = json.keys.first;
    return PropertyFactory.getProperty(json, idn);
  }

  @override
  Map<String, Object?> toJson(Property<Object> object) {
    final Map<String, Object?> json = object.toJson();
    final String idn = json['idn'] as String;

    return <String, Object?>{
      idn: json,
    };
  }
}
