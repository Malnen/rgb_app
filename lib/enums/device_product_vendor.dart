import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device.dart';

enum DeviceProductVendor {
  corsairK70(
    name:'Corsair k70',
    productVendor:'1b1c:1b33',
    icon: Icons.keyboard
  ),
  steelSeriesRival100(
    name:'SteelSeries Rival 100',
    productVendor:'1038:1702',
    icon: Icons.mouse
  ),
  unknown(
    name:'Unknown',
    productVendor:'',
    icon: Icons.devices
  );

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
      case '1b1c:1b33':
        return DeviceProductVendor.corsairK70;
      case '1038:1702':
        return DeviceProductVendor.steelSeriesRival100;
      default:
        return DeviceProductVendor.unknown;
    }
  }
}
