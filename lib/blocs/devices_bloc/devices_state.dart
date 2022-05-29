import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';

import '../../devices/device.dart';

abstract class DevicesState extends Equatable {}

class DevicesInitialState extends DevicesState {
  final List<Device> devices;
  final List<Device> availableDevices;
  final List<DeviceInterface> deviceInstances;
  final Key key;

  DevicesInitialState({
    required this.devices,
    required this.deviceInstances,
    required this.availableDevices,
  }) : key = UniqueKey();

  DevicesInitialState copyWith({
    List<Device>? devices,
    List<Device>? availableDevices,
    List<DeviceInterface>? deviceInstances,
  }) {
    return DevicesInitialState(
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
