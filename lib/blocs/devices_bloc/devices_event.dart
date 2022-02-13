import 'package:equatable/equatable.dart';

import '../../devices/device.dart';

abstract class DevicesEvent extends Equatable {}

class AddDeviceEvent extends DevicesEvent {
  final Device device;

  AddDeviceEvent({required this.device});

  @override
  List<Object> get props => <Object>[device];
}

class RemoveDeviceEvent extends DevicesEvent {
  final Device device;

  RemoveDeviceEvent({required this.device});

  @override
  List<Object> get props => <Object>[device];
}