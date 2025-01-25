import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/models/device_product_vendor.dart';

part '../generated/models/device_data.freezed.dart';
part '../generated/models/device_data.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class DeviceData with _$DeviceData {
  DeviceData._();

  factory DeviceData({
    required DeviceProductVendor deviceProductVendor,
    @Default(0) int offsetX,
    @Default(0) int offsetY,
    @Default(false) bool connected,
  }) = _DeviceData;

  factory DeviceData.fromJson(Map<String, Object?> json) => _$DeviceDataFromJson(json);

  factory DeviceData.empty() => DeviceData(deviceProductVendor: DeviceProductVendor.unknownProductVendor());

  bool get isKnownDevice => !deviceProductVendor.isUnknown;
}
