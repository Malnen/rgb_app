import 'package:equatable/equatable.dart';

class Option extends Equatable {
  final int value;
  final String name;
  final bool selected;

  Option({
    required this.value,
    required this.name,
    required this.selected,
  });

  Map<String, Object> toJson() {
    return <String, Object>{
      'value': value,
      'name': name,
      'selected': selected,
    };
  }

  Option copyWith({
    int? value,
    String? name,
    bool? selected,
  }) {
    return Option(
      value: value ?? this.value,
      name: name ?? this.name,
      selected: selected ?? this.selected,
    );
  }

  factory Option.fromJson(Map<String, Object?> json) {
    return Option(
      value: json['value'] as int,
      name: json['name'] as String,
      selected: json['selected'] as bool,
    );
  }

  @override
  List<Object> get props => <Object>[
        value,
        name,
        selected,
      ];
}
