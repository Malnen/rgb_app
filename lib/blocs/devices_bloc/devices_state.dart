import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/device_data.dart';

import '../../devices/device.dart';

class DevicesState extends Equatable {
  final List<Device> devices;
  final List<DeviceData> devicesData;
  final List<Device> availableDevices;
  final List<DeviceInterface> deviceInstances;
  final Key key;

  DevicesState({
    required this.devices,
    required this.devicesData,
    required this.deviceInstances,
    required this.availableDevices,
  }) : key = UniqueKey();

  factory DevicesState.empty() {
    return DevicesState(devices: [], devicesData: [], deviceInstances: [], availableDevices: []);
  }

  DevicesState copyWith({
    List<Device>? devices,
    List<DeviceData>? devicesData,
    List<Device>? availableDevices,
    List<DeviceInterface>? deviceInstances,
  }) {
    return DevicesState(
      devices: devices ?? this.devices,
      devicesData: devicesData ?? this.devicesData,
      availableDevices: availableDevices ?? this.availableDevices,
      deviceInstances: deviceInstances ?? this.deviceInstances,
    );
  }

  static DevicesState fromJson(Map<String, dynamic> json) {
    return DevicesState(
      devicesData: _mapDeviceData(json['devicesData'] as List<dynamic>),
      availableDevices: [],
      deviceInstances: [],
      devices: [],
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
          (dynamic element) => DeviceData.fromJson(element as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  List<Object> get props => <Object>[
        devices,
        devicesData,
        availableDevices,
        deviceInstances,
        key,
      ];
}
