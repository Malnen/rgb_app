import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:equatable/equatable.dart';

class Device extends Equatable {
  final DeviceProductVendor deviceProductVendor;
  final String vendorId;
  final String productId;
  final int offsetX;
  final int offsetY;

  const Device({
    required this.deviceProductVendor,
    required this.vendorId,
    required this.productId,
    this.offsetX = 0,
    this.offsetY = 0,
  });

  factory Device.empty() {
    return Device(
      deviceProductVendor: UnknownProductVendor(),
      vendorId: '',
      productId: '',
    );
  }

  factory Device.create({
    required DeviceProductVendor deviceProductVendor,
    required String vendorId,
    required String productId,
  }) {
    return Device(
      deviceProductVendor: deviceProductVendor,
      vendorId: vendorId,
      productId: productId,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        deviceProductVendor,
        vendorId,
        productId,
      ];
}
