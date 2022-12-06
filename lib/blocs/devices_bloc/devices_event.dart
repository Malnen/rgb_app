import 'package:equatable/equatable.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/device_data.dart';

abstract class DevicesEvent extends Equatable {
  @override
  List<Object?> get props => <Object>[];
}

class AddDeviceEvent extends DevicesEvent {
  final DeviceData deviceData;

  AddDeviceEvent({required this.deviceData});

  @override
  List<Object?> get props => <Object>[deviceData];
}

class RemoveDeviceEvent extends DevicesEvent {
  final DeviceData deviceData;

  RemoveDeviceEvent({required this.deviceData});

  @override
  List<Object> get props => <Object>[deviceData];
}

class RestoreDevicesEvent extends DevicesEvent {}

class LoadAvailableDevicesEvent extends DevicesEvent {}

class UpdateDevices extends DevicesEvent {
  final List<DeviceData> devicesData;
  final List<DeviceData> connectedDevices;
  final List<DeviceData> availableDevices;

  UpdateDevices({
    required this.devicesData,
    required this.connectedDevices,
    required this.availableDevices,
  });

  @override
  List<Object> get props => <Object>[
        devicesData,
        connectedDevices,
        availableDevices,
      ];
}

class ReorderDevicesEvent extends DevicesEvent {
  final int oldIndex;
  final int newIndex;

  ReorderDevicesEvent({
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object> get props => <Object>[
        oldIndex,
        newIndex,
      ];
}

class UpdateDeviceOffsetEvent extends DevicesEvent {
  final int offsetX;
  final int offsetY;
  final DeviceInterface deviceInterface;

  UpdateDeviceOffsetEvent({
    required this.offsetX,
    required this.offsetY,
    required this.deviceInterface,
  });

  @override
  List<Object> get props => <Object>[
        offsetX,
        offsetY,
        deviceInterface,
      ];
}
