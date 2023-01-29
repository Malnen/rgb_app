import 'package:equatable/equatable.dart';
import 'package:rgb_app/models/option.dart';

class Options extends Equatable {
  final Set<Option> options;

  Options(this.options);

  @override
  List<Object> get props => <Object>[options];

  Map<String, Object> toJson() {
    return <String, Object>{
      'options': options.map((Option option) => option.toJson()).toList(),
    };
  }

  factory Options.fromJson(Map<String, Object> json) {
    final List<Map<String, dynamic>> options = List<Map<String, dynamic>>.from(json['options'] as List<dynamic>);
    final Set<Option> parsedOptions = options.map(Option.fromJson).toSet();

    return Options(parsedOptions);
  }
}
