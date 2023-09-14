import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/device_data.dart';

class DevicesState extends Equatable {
  final List<DeviceData> connectedDevices;
  final List<DeviceData> devicesData;
  final List<DeviceData> availableDevices;
  final List<DeviceInterface> deviceInstances;
  final Key key;

  DevicesState({
    required this.devicesData,
    required this.deviceInstances,
    required this.availableDevices,
    List<DeviceData>? connectedDevices,
  })  : connectedDevices = connectedDevices ?? <DeviceData>[],
        key = UniqueKey();

  factory DevicesState.empty() {
    return DevicesState(
      devicesData: <DeviceData>[],
      deviceInstances: <DeviceInterface>[],
      availableDevices: <DeviceData>[],
    );
  }

  DevicesState copyWith({
    List<DeviceData>? devicesData,
    List<DeviceData>? availableDevices,
    List<DeviceInterface>? deviceInstances,
    List<DeviceData>? connectedDevices,
  }) {
    return DevicesState(
      devicesData: devicesData ?? this.devicesData,
      availableDevices: availableDevices ?? this.availableDevices,
      deviceInstances: deviceInstances ?? this.deviceInstances,
      connectedDevices: connectedDevices ?? this.connectedDevices,
    );
  }

  static DevicesState fromJson(Map<String, Object?> json) {
    return DevicesState(
      devicesData: _mapDeviceData(json['devicesData'] as List<Object?>),
      availableDevices: <DeviceData>[],
      deviceInstances: <DeviceInterface>[],
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'devicesData': devicesData,
    };
  }

  static List<DeviceData> _mapDeviceData(List<Object?> json) {
    return json
        .map(
          (Object? element) => DeviceData.fromJson(element as Map<String, Object?>),
        )
        .toList();
  }

  @override
  List<Object> get props => <Object>[
        devicesData,
        availableDevices,
        deviceInstances,
        key,
      ];
}
