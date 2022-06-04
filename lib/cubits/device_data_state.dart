import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../models/device_data.dart';

class DevicesDataState extends Equatable {
  final Key key;
  final List<DeviceData> devicesData;

  DevicesDataState({
    required this.devicesData,
  }) : key = UniqueKey();

  @override
  List<Object> get props => <Object>[
        devicesData,
        key,
      ];

  static DevicesDataState fromJson(Map<String, dynamic> json) {
    return DevicesDataState(
      devicesData: _mapDeviceData(json['devicesData'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'devicesData': devicesData,
    };
  }

  static List<DeviceData> _mapDeviceData(List<dynamic> json) {
    return json
        .map(
          (dynamic element) =>
              DeviceData.fromJson(element as Map<String, dynamic>),
        )
        .toList();
  }
}
