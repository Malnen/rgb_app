import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/effect_grid_data.freezed.dart';
part '../generated/models/effect_grid_data.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class EffectGridData with _$EffectGridData {
  const factory EffectGridData({
    required int sizeX,
    required int sizeY,
    required int minSizeX,
    required int minSizeY,
  }) = _EffectGridData;

  factory EffectGridData.initial() => const EffectGridData(
        sizeX: 26,
        sizeY: 11,
        minSizeX: 20,
        minSizeY: 9,
      );

  factory EffectGridData.fromJson(Map<String, Object?> json) => _$EffectGridDataFromJson(json);
}
