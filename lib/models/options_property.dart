import 'package:collection/collection.dart';
import 'package:rgb_app/models/option.dart';
import 'package:rgb_app/models/property.dart';

class OptionProperty extends Property<Set<Option>> {
  Option? _selectedOption;

  OptionProperty({
    required super.name,
    required super.idn,
    required super.initialValue,
  }) {
    addValueChangeListener((Set<Option> options) {
      _selectedOption = options.firstWhereOrNull((Option option) => option.selected);
    });
  }

  Option get selectedOption => _selectedOption ?? value.first;

  @override
  Map<String, Object> getData() => <String, Object>{
        'value': value.map((Option option) => option.toJson()).toList(),
    };
}
