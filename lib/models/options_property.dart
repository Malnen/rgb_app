import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/property.dart';

class OptionProperty extends Property<Set<Option>> {
  OptionProperty({
    required super.value,
    required super.name,
    super.onChanged,
  });

  @override
  Map<String, Object> getData() {
    return <String, Object>{
      'value': value.map((Option option) => option.toJson()).toList(),
    };
  }
}
