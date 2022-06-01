import 'package:equatable/equatable.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

class DeviceData extends Equatable {
  final DeviceProductVendor deviceProductVendor;

  DeviceData({required this.deviceProductVendor});

  @override
  List<Object> get props => <Object>[
        deviceProductVendor,
      ];

  DeviceData.fromJson(Map<String, dynamic> json)
      : deviceProductVendor =
            json['deviceProductVendor'] as DeviceProductVendor;

  Map<String, dynamic> toJson() {
    return {
      'deviceProductVendor': deviceProductVendor,
    };
  }
}
