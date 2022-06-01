import 'package:flutter/material.dart';

abstract class DeviceProductVendor {
  static const String corsairK70 = '1b1c:1b33';
  static const String steelSeriesRival100 = '1038:1702';
  static const String unknown = '';

  const DeviceProductVendor({
    required this.name,
    required this.productVendor,
    required this.icon,
  });

  final String name;
  final String productVendor;
  final IconData icon;

  static DeviceProductVendor getType(String deviceId) {
    deviceId = deviceId.toLowerCase();
    switch (deviceId) {
      case corsairK70:
        return CorsairK70ProductVendor();
      case steelSeriesRival100:
        return SteelSeriesRival100ProductVendor();
      default:
        return UnknownProductVendor();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'productVendor': productVendor,
    };
  }
}

class CorsairK70ProductVendor extends DeviceProductVendor {
  CorsairK70ProductVendor()
      : super(
          name: 'Corsair k70',
          productVendor: DeviceProductVendor.corsairK70,
          icon: Icons.keyboard,
        );
}

class SteelSeriesRival100ProductVendor extends DeviceProductVendor {
  SteelSeriesRival100ProductVendor()
      : super(
          name: 'SteelSeries Rival 100',
          productVendor: DeviceProductVendor.steelSeriesRival100,
          icon: Icons.mouse,
        );
}

class UnknownProductVendor extends DeviceProductVendor {
  UnknownProductVendor()
      : super(
          name: 'Unknown',
          productVendor: DeviceProductVendor.unknown,
          icon: Icons.devices,
        );
}
