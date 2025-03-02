import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/models/device_product_vendor.dart';

part '../generated/models/device_data.freezed.dart';
part '../generated/models/device_data.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class DeviceData with _$DeviceData {
  @override
  final DeviceProductVendor deviceProductVendor;
  @override
  final int offsetX;
  @override
  final int offsetY;
  @override
  final bool connected;

  DeviceData({
    required this.deviceProductVendor,
    this.offsetX = 0,
    this.offsetY = 0,
    this.connected = false,
  });

  factory DeviceData.fromJson(Map<String, Object?> json) => _$DeviceDataFromJson(json);

  factory DeviceData.empty() => DeviceData(deviceProductVendor: DeviceProductVendor.unknownProductVendor());

  Map<String, Object?> toJson() => _$DeviceDataToJson(this);

  bool get isKnownDevice => !deviceProductVendor.isUnknown;
}
