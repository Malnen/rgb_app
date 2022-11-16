import 'package:equatable/equatable.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

class DeviceData extends Equatable {
  final DeviceProductVendor deviceProductVendor;

  DeviceData({required this.deviceProductVendor});

  @override
  List<Object> get props => <Object>[deviceProductVendor];

  DeviceData.fromJson(Map<String, dynamic> json)
      : deviceProductVendor = DeviceProductVendor.fromJson(json['deviceProductVendor'] as Map<String, dynamic>);

  Map<String, dynamic> toJson() {
    return {
      'deviceProductVendor': deviceProductVendor,
    };
  }
}
