import 'package:equatable/equatable.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';

import '../../devices/device.dart';

abstract class DevicesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddDeviceEvent extends DevicesEvent {
  final Device device;
  final KeyBloc? keyBloc;

  AddDeviceEvent({
    required this.device,
    this.keyBloc,
  });

  @override
  List<Object?> get props => <Object?>[
        device,
        keyBloc,
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
