import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/json_converters/vector_3_converter.dart';
import 'package:vector_math/vector_math.dart';

part '../generated/models/effect_grid_data.freezed.dart';
part '../generated/models/effect_grid_data.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class EffectGridData with _$EffectGridData {
  @override
  @Vector3Converter()
  final Vector3 size;
  @override
  @Vector3Converter()
  final Vector3 minSize;

  const EffectGridData({
    required this.size,
    required this.minSize,
  });

  int get sizeX => size.x.toInt();

  int get sizeY => size.y.toInt();

  int get sizeZ => size.z.toInt();

  int get minSizeX => minSize.x.toInt();

  int get minSizeY => minSize.y.toInt();

  int get minSizeZ => minSize.z.toInt();

  factory EffectGridData.initial() => EffectGridData(
        size: Vector3(26, 12, 8),
        minSize: Vector3(20, 12, 8),
      );

  factory EffectGridData.fromJson(Map<String, Object?> json) => _$EffectGridDataFromJson(json);

  Map<String, Object?> toJson() => _$EffectGridDataToJson(this);
}
