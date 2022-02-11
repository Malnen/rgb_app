enum DeviceProductVendor {
  corsairK70,
  steelSeriesRival100,
  unknown,
}

extension DeviceProductVendorExtension on DeviceProductVendor {
  String get name {
    switch (this) {
      case DeviceProductVendor.corsairK70:
        return 'Corsair k70';
      case DeviceProductVendor.steelSeriesRival100:
        return 'SteelSeries Rival 100';
      default:
        return 'Unknown';
    }
  }

  static DeviceProductVendor getType(String deviceId) {
    deviceId = deviceId.toLowerCase();

    switch (deviceId) {
      case '1b1c:1b33':
        return DeviceProductVendor.corsairK70;
      case '1038:1702':
        return DeviceProductVendor.steelSeriesRival100;
      default:
        return DeviceProductVendor.unknown;
    }
  }
}
