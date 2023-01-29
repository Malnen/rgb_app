import 'package:rgb_app/models/property.dart';

class NumericProperty extends Property<double> {
  final double min;
  final double max;

  NumericProperty({
    required super.value,
    required super.name,
    required this.min,
    required this.max,
    super.onChanged,
  });

  @override
  Map<String, Object> getData() {
    return <String, Object>{
      'min': min,
      'max': max,
    };
  }

  NumericProperty copyWith({
    final double? value,
    final String? name,
    final double? min,
    final double? max,
  }) {
    return NumericProperty(
      value: value ?? this.value,
      name: name ?? this.name,
      min: min ?? this.min,
      max: max ?? this.max,
    );
  }
}
