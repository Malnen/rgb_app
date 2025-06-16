import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/device_product_vendor.freezed.dart';
part '../generated/models/device_product_vendor.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class DeviceProductVendor with _$DeviceProductVendor {
  static const String corsairK70Lux = '1b1c:1b33';
  static const String corsairK70MKIILowProfile = '1b1c:1b55';
  static const String corsairK95Platinum = '1b1c:1b2d';
  static const String corsairICueLinkHub = '1b1c:0c3f';
  static const String corsairVirtuoso = '1b1c:0a40';
  static const String steelSeriesRival100 = '1038:1702';
  static const String steelSeriesRival3 = '1038:1824';
  static const String auraLEDController = '0b05:19af';
  static const String unknown = '';

  @override
  final String productVendor;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String name;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final IconData? icon;

  DeviceProductVendor({
    required this.productVendor,
    this.name = '',
    this.icon,
  });

  factory DeviceProductVendor.unknownProductVendor() => DeviceProductVendor(
        name: 'Unknown',
        productVendor: unknown,
        icon: Icons.question_mark,
      );

  String get productId => productVendor.substring(5);

  String get vendorId => productVendor.substring(0, 4);

  bool get isUnknown => productVendor == unknown;

  static DeviceProductVendor getByProductVendor(Map<String, Object?> data) {
    final String? productId = data['productId'] as String?;
    final String? vendorId = data['vendorId'] as String?;
    final String deviceId = '$vendorId:$productId';

    return getType(deviceId);
  }

  static DeviceProductVendor getType(String deviceId) {
    deviceId = deviceId.toLowerCase();
    return switch (deviceId) {
      corsairK70Lux => DeviceProductVendor(
          name: 'Corsair K70 LUX',
          productVendor: corsairK70Lux,
          icon: Icons.keyboard,
        ),
      corsairK70MKIILowProfile => DeviceProductVendor(
          name: 'Corsair K70 MK II Low Profile',
          productVendor: corsairK70MKIILowProfile,
          icon: Icons.keyboard,
        ),
      corsairK95Platinum => DeviceProductVendor(
          name: 'Corsair K95 Platinum',
          productVendor: corsairK95Platinum,
          icon: Icons.keyboard,
        ),
      corsairICueLinkHub => LightningControllerDeviceProductVendor(
          name: 'Corsair iCue link hub',
          productVendor: corsairICueLinkHub,
          icon: Icons.device_hub,
        ),
      corsairVirtuoso => DeviceProductVendor(
          name: 'Corsair Virtuoso',
          productVendor: corsairVirtuoso,
          icon: Icons.headphones,
        ),
      steelSeriesRival100 => DeviceProductVendor(
          name: 'SteelSeries Rival 100',
          productVendor: steelSeriesRival100,
          icon: Icons.mouse,
        ),
      steelSeriesRival3 => DeviceProductVendor(
          name: 'SteelSeries Rival 3',
          productVendor: steelSeriesRival3,
          icon: Icons.mouse,
        ),
      auraLEDController => DeviceProductVendor(
          name: 'Aura LED Controller',
          productVendor: auraLEDController,
          icon: Icons.square_sharp,
        ),
      _ => DeviceProductVendor.unknownProductVendor(),
    };
  }

  factory DeviceProductVendor.fromJson(Map<String, Object?> json) => getType(json['productVendor'] as String);

  Map<String, Object?> toJson() => _$DeviceProductVendorToJson(this);
}

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class LightningControllerDeviceProductVendor extends DeviceProductVendor with _$LightningControllerDeviceProductVendor {
  @override
  final String productVendor;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String name;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final IconData? icon;

  LightningControllerDeviceProductVendor({
    required this.productVendor,
    this.name = '',
    this.icon,
  }) : super(productVendor: productVendor, name: name, icon: icon);

  @override
  Map<String, Object?> toJson() => _$LightningControllerDeviceProductVendorToJson(this);
}
