import 'package:rgb_app/models/options.dart';
import 'package:rgb_app/models/property.dart';

class OptionProperty extends Property<Options> {
  OptionProperty({
    required super.value,
    required super.name,
    super.onChanged,
  });

  @override
  Map<String, Object> getData() {
    return <String, Object>{
      'value': value.toJson(),
    };
  }
}
