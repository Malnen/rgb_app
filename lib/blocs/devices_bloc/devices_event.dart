import 'package:equatable/equatable.dart';
import 'package:rgb_app/devices/device.dart';

abstract class DevicesEvent extends Equatable {
  @override
  List<Object?> get props => <Object>[];
}

class AddDeviceEvent extends DevicesEvent {
  final Device device;

  AddDeviceEvent({required this.device});

  @override
  List<Object?> get props => <Object>[device];
}

class RemoveDeviceEvent extends DevicesEvent {
  final Device device;

  RemoveDeviceEvent({required this.device});

  @override
  List<Object> get props => <Object>[device];
}

class RestoreDevicesEvent extends DevicesEvent {}

class LoadAvailableDevicesEvent extends DevicesEvent {}

class UpdateDevices extends DevicesEvent {
  final List<Device> devices;
  final List<Device> connectedDevices;
  final List<Device> availableDevices;

  UpdateDevices({
    required this.devices,
    required this.connectedDevices,
    required this.availableDevices,
  });

  @override
  List<Object> get props => <Object>[
        devices,
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
