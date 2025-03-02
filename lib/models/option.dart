import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/option.freezed.dart';
part '../generated/models/option.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class Option with _$Option {
  @override
  final int value;
  @override
  final String name;
  @override
  final bool selected;

  Option({
    required this.value,
    required this.name,
    required this.selected,
  });

  factory Option.fromJson(Map<String, Object?> json) => _$OptionFromJson(json);

  Map<String, Object?> toJson() => _$OptionToJson(this);
}
