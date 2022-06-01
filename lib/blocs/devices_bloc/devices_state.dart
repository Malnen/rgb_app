import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';

import '../../devices/device.dart';

class DevicesState extends Equatable {
  final List<Device> devices;
  final List<Device> availableDevices;
  final List<DeviceInterface> deviceInstances;
  final Key key;

  DevicesState({
    required this.devices,
    required this.deviceInstances,
    required this.availableDevices,
  }) : key = UniqueKey();

  DevicesState copyWith({
    List<Device>? devices,
    List<Device>? availableDevices,
    List<DeviceInterface>? deviceInstances,
  }) {
    return DevicesState(
      devices: devices ?? this.devices,
      availableDevices: availableDevices ?? this.availableDevices,
      deviceInstances: deviceInstances ?? this.deviceInstances,
    );
  }

  @override
  List<Object> get props => <Object>[
        devices,
        availableDevices,
        deviceInstances,
        key,
      ];
}
