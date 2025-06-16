import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/sub_device_details.freezed.dart';
part '../generated/models/sub_device_details.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class SubDeviceDetails with _$SubDeviceDetails {
  @override
  final String deviceId;
  @override
  final String uniqueId;
  @override
  final String name;

  SubDeviceDetails({
    required this.deviceId,
    required this.uniqueId,
    required this.name,
  });

  bool get isUnknown => uniqueId.isEmpty;

  factory SubDeviceDetails.unknownSubDeviceDetails() => SubDeviceDetails(deviceId: '', uniqueId: '', name: '');

  factory SubDeviceDetails.fromJson(Map<String, Object?> json) => _$SubDeviceDetailsFromJson(json);

  Map<String, Object?> toJson() => _$SubDeviceDetailsToJson(this);
}
