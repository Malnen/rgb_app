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

  String get productVendor {
    switch (this) {
      case DeviceProductVendor.corsairK70:
        return '1b1c:1b33';
      case DeviceProductVendor.steelSeriesRival100:
        return '1038:1702';
      default:
        return 'unknown';
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
