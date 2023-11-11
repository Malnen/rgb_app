import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/property.dart';

class OptionProperty extends Property<Set<Option>> {
  OptionProperty({
    required super.name,
    required super.initialValue,
  });

  @override
  Map<String, Object> getData() {
    return <String, Object>{
      'value': value.map((Option option) => option.toJson()).toList(),
    };
  }
}
