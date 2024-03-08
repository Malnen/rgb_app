import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/option.freezed.dart';
part '../generated/models/option.g.dart';

@freezed
class Option with _$Option {
  const factory Option({
    required int value,
    required String name,
    required bool selected,
  }) = _Option;

  factory Option.fromJson(Map<String, Object?> json) => _$OptionFromJson(json);
}
