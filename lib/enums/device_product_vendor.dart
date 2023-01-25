import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class DeviceProductVendor extends Equatable {
  static const String corsairK70 = '1b1c:1b33';
  static const String corsairVirtuoso = '1b1c:0a40';
  static const String steelSeriesRival100 = '1038:1702';
  static const String steelSeriesRival3 = '1038:1824';
  static const String unknown = '';

  const DeviceProductVendor({
    required this.name,
    required this.productVendor,
    required this.icon,
  });

  final String name;
  final String productVendor;
  final IconData icon;

  String get productId => productVendor.substring(5);

  String get vendorId => productVendor.substring(0, 4);

  static DeviceProductVendor getType(String deviceId) {
    deviceId = deviceId.toLowerCase();
    switch (deviceId) {
      case corsairK70:
        return CorsairK70ProductVendor();
      case corsairVirtuoso:
        return CorsairVirtuosoProductVendor();
      case steelSeriesRival100:
        return SteelSeriesRival100ProductVendor();
      case steelSeriesRival3:
        return SteelSeriesRival3ProductVendor();
      default:
        return UnknownProductVendor();
    }
  }

  static DeviceProductVendor fromJson(final Map<String, dynamic> json) {
    return getType(json['productVendor'] as String);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'productVendor': productVendor,
    };
  }

  @override
  List<Object> get props => <Object>[
        name,
        productVendor,
        icon,
      ];
}

class CorsairK70ProductVendor extends DeviceProductVendor {
  CorsairK70ProductVendor()
      : super(
          name: 'Corsair k70',
          productVendor: DeviceProductVendor.corsairK70,
          icon: Icons.keyboard,
        );
}

class CorsairVirtuosoProductVendor extends DeviceProductVendor {
  CorsairVirtuosoProductVendor()
      : super(
          name: 'Corsair Virtuoso',
          productVendor: DeviceProductVendor.corsairVirtuoso,
          icon: Icons.headphones,
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
class SteelSeriesRival3ProductVendor extends DeviceProductVendor {
  SteelSeriesRival3ProductVendor()
      : super(
    name: 'SteelSeries Rival 3',
    productVendor: DeviceProductVendor.steelSeriesRival3,
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
