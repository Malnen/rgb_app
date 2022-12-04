import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:equatable/equatable.dart';
import 'package:rgb_app/models/device_data.dart';

class Device extends Equatable {
  final DeviceProductVendor deviceProductVendor;
  final int offsetX;
  final int offsetY;
  final bool connected;

  bool get isKnownDevice => deviceProductVendor is! UnknownProductVendor;

  const Device({
    required this.deviceProductVendor,
    this.offsetX = 0,
    this.offsetY = 0,
    this.connected = false,
  });

  factory Device.empty() {
    return Device(
      deviceProductVendor: UnknownProductVendor(),
    );
  }

  factory Device.fromDeviceData(final DeviceData deviceData) {
    final DeviceProductVendor deviceProductVendor = deviceData.deviceProductVendor;
    return Device(
      deviceProductVendor: deviceProductVendor,
    );
  }

  factory Device.create({
    required final DeviceProductVendor deviceProductVendor,
  }) {
    return Device(
      deviceProductVendor: deviceProductVendor,
      connected: true,
    );
  }

  Device copyWith({
    final DeviceProductVendor? deviceProductVendor,
    final String? vendorId,
    final String? productId,
    final int? offsetX,
    final int? offsetY,
    final bool? connected,
  }) {
    return Device(
      deviceProductVendor: deviceProductVendor ?? this.deviceProductVendor,
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
      connected: connected ?? this.connected,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        deviceProductVendor,
      ];
}
