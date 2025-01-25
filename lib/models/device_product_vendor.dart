import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/device_product_vendor.freezed.dart';
part '../generated/models/device_product_vendor.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class DeviceProductVendor with _$DeviceProductVendor {
  static const String corsairK70 = '1b1c:1b33';
  static const String corsairVirtuoso = '1b1c:0a40';
  static const String steelSeriesRival100 = '1038:1702';
  static const String steelSeriesRival3 = '1038:1824';
  static const String auraLEDController = '0b05:19af';
  static const String unknown = '';

  DeviceProductVendor._();

  factory DeviceProductVendor({
    required String productVendor,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    @Default('')
    String name,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    IconData? icon,
  }) = _DeviceProductVendor;

  factory DeviceProductVendor.unknownProductVendor() => DeviceProductVendor(
        name: 'Unknown',
        productVendor: unknown,
        icon: Icons.devices,
      );

  String get productId => productVendor.substring(5);

  String get vendorId => productVendor.substring(0, 4);

  bool get isUnknown => productVendor == unknown;

  static DeviceProductVendor getByProductVendor(Map<String, Object?> data) {
    final String productId = data['productId'] as String;
    final String vendorId = data['vendorId'] as String;
    final String deviceId = '$vendorId:$productId';

    return getType(deviceId);
  }

  static DeviceProductVendor getType(String deviceId) {
    deviceId = deviceId.toLowerCase();
    return switch (deviceId) {
      corsairK70 => DeviceProductVendor(
          name: 'Corsair k70',
          productVendor: corsairK70,
          icon: Icons.keyboard,
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
}
