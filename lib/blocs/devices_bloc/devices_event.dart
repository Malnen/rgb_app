import 'package:equatable/equatable.dart';

import '../../devices/device.dart';

abstract class DevicesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddDeviceEvent extends DevicesEvent {
  final Device device;

  AddDeviceEvent({
    required this.device
  });

  @override
  List<Object?> get props => <Object?>[
        device
      ];
}

class RemoveDeviceEvent extends DevicesEvent {
  final Device device;

  RemoveDeviceEvent({required this.device});

  @override
  List<Object> get props => <Object>[device];
}

class RestoreDevicesEvent extends DevicesEvent {}

class LoadAvailableDevicesEvent extends DevicesEvent {}
