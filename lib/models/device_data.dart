import 'package:equatable/equatable.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

class DeviceData extends Equatable {
  final DeviceProductVendor deviceProductVendor;
  final int offsetX;
  final int offsetY;

  DeviceData({
    required this.deviceProductVendor,
    this.offsetX = 0,
    this.offsetY = 0,
  });

  @override
  List<Object> get props => <Object>[deviceProductVendor];

  DeviceData.fromJson(final Map<String, dynamic> json)
      : deviceProductVendor = DeviceProductVendor.fromJson(json['deviceProductVendor'] as Map<String, dynamic>),
        offsetX = json['offsetX'] as int? ?? 0,
        offsetY = json['offsetY'] as int? ?? 0;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'deviceProductVendor': deviceProductVendor,
      'offsetX': offsetX,
      'offsetY': offsetY,
    };
  }
}
