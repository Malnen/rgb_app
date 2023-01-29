import 'package:equatable/equatable.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

class DeviceData extends Equatable {
  final DeviceProductVendor deviceProductVendor;
  final int offsetX;
  final int offsetY;
  final bool connected;

  DeviceData({
    required this.deviceProductVendor,
    this.offsetX = 0,
    this.offsetY = 0,
    this.connected = false,
  });

  @override
  List<Object> get props => <Object>[
        deviceProductVendor,
      ];

  DeviceData.fromJson(Map<String, dynamic> json)
      : deviceProductVendor = DeviceProductVendor.fromJson(json['deviceProductVendor'] as Map<String, dynamic>),
        offsetX = json['offsetX'] as int? ?? 0,
        offsetY = json['offsetY'] as int? ?? 0,
        connected = false;

  factory DeviceData.empty() {
    return DeviceData(deviceProductVendor: UnknownProductVendor());
  }

  DeviceData copyWith({
    final DeviceProductVendor? deviceProductVendor,
    final int? offsetX,
    final int? offsetY,
    final bool? connected,
  }) {
    return DeviceData(
      deviceProductVendor: deviceProductVendor ?? this.deviceProductVendor,
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
      connected: connected ?? this.connected,
    );
  }

  bool get isKnownDevice => deviceProductVendor is! UnknownProductVendor;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'deviceProductVendor': deviceProductVendor,
      'offsetX': offsetX,
      'offsetY': offsetY,
    };
  }
}
