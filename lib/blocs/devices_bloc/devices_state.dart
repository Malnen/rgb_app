import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/device_data.dart';

class DevicesState extends Equatable {
  final List<Device> devices;
  final List<Device> connectedDevices;
  final List<DeviceData> devicesData;
  final List<Device> availableDevices;
  final List<DeviceInterface> deviceInstances;
  final Key key;

  DevicesState(
      {required this.devices,
      required this.devicesData,
      required this.deviceInstances,
      required this.availableDevices,
      final List<Device>? connectedDevices})
      : connectedDevices = connectedDevices ?? <Device>[],
        key = UniqueKey();

  factory DevicesState.empty() {
    return DevicesState(
      devices: <Device>[],
      devicesData: <DeviceData>[],
      deviceInstances: <DeviceInterface>[],
      availableDevices: <Device>[],
    );
  }

  DevicesState copyWith({
    final List<Device>? devices,
    final List<DeviceData>? devicesData,
    final List<Device>? availableDevices,
    final List<DeviceInterface>? deviceInstances,
    final List<Device>? connectedDevices,
  }) {
    return DevicesState(
      devices: devices ?? this.devices,
      devicesData: devicesData ?? this.devicesData,
      availableDevices: availableDevices ?? this.availableDevices,
      deviceInstances: deviceInstances ?? this.deviceInstances,
      connectedDevices: connectedDevices ?? this.connectedDevices,
    );
  }

  static DevicesState fromJson(final Map<String, dynamic> json) {
    return DevicesState(
      devicesData: _mapDeviceData(json['devicesData'] as List<dynamic>),
      availableDevices: <Device>[],
      deviceInstances: <DeviceInterface>[],
      devices: <Device>[],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'devicesData': devicesData,
    };
  }

  static List<DeviceData> _mapDeviceData(final List<dynamic> json) {
    return json
        .map(
          (final Object? element) => DeviceData.fromJson(element as Map<String, dynamic>),
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
