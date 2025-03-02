import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/effect_grid_data.freezed.dart';
part '../generated/models/effect_grid_data.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class EffectGridData with _$EffectGridData {
  @override
  final int sizeX;
  @override
  final int sizeY;
  @override
  final int minSizeX;
  @override
  final int minSizeY;

  const EffectGridData({
    required this.sizeX,
    required this.sizeY,
    required this.minSizeX,
    required this.minSizeY,
  });

  factory EffectGridData.initial() => const EffectGridData(
        sizeX: 26,
        sizeY: 11,
        minSizeX: 20,
        minSizeY: 9,
      );

  factory EffectGridData.fromJson(Map<String, Object?> json) => _$EffectGridDataFromJson(json);

  Map<String, Object?> toJson() => _$EffectGridDataToJson(this);
}
