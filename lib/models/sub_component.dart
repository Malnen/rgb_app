import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math.dart';

part '../generated/models/sub_component.freezed.dart';
part '../generated/models/sub_component.g.dart';

@freezed
@JsonSerializable()
class SubComponent with _$SubComponent {
  @override
  final int deviceType;
  @override
  final int coolerType;
  @override
  final List<int> rawData;
  @override
  final String deviceIDString;
  @override
  final String uniqueIDString;
  @override
  final String name;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<Vector3> ledPositions;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Vector3 size;

  SubComponent({
    this.deviceType = 0,
    this.coolerType = 0,
    this.deviceIDString = '',
    this.uniqueIDString = '',
    this.name = '',
    List<int>? rawData,
    List<Vector3>? ledPositions,
    Vector3? size,
  })  : rawData = rawData ?? <int>[],
        ledPositions = ledPositions ?? <Vector3>[],
        size = size ?? Vector3.zero();

  factory SubComponent.fromJson(Map<String, Object?> json) => _$SubComponentFromJson(json);

  Map<String, Object?> toJson() => _$SubComponentToJson(this);
}
