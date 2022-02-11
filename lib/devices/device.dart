import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:equatable/equatable.dart';

class Device extends Equatable {
  final DeviceProductVendor deviceProductVendor;

  const Device({required this.deviceProductVendor});

  factory Device.empty() {
    return const Device(deviceProductVendor: DeviceProductVendor.unknown);
  }

  factory Device.create({required DeviceProductVendor deviceProductVendor}) {
    return Device(deviceProductVendor: deviceProductVendor);
  }

  @override
  List<Object?> get props => <Object?>[
        deviceProductVendor,
      ];
}
