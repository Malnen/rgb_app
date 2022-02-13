import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/devices/device_interface.dart';

import '../../devices/device.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  DevicesBloc()
      : super(DevicesInitialState(
          devices: [],
          deviceInstances: [],
        )) {
    on<AddDeviceEvent>(_onAddDeviceEvent);
    on<RemoveDeviceEvent>(_onRemoveDeviceEvent);
  }

  Future<void> _onAddDeviceEvent(
      AddDeviceEvent event, Emitter<DevicesState> emit) async {
    final DevicesState currentState = state;
    if (currentState is DevicesInitialState) {
      _addDeviceIfNew(event).then((DevicesState state) => emit(state));
    }
  }

  Future<void> _onRemoveDeviceEvent(
      RemoveDeviceEvent event, Emitter<DevicesState> emit) async {
    final DevicesState currentState = state;
    if (currentState is DevicesInitialState) {
      _removeDeviceIfExist(event).then((DevicesState state) => emit(state));
    }
  }

  Future<DevicesState> _addDeviceIfNew(AddDeviceEvent event) async {
    final DevicesInitialState currentState = state as DevicesInitialState;
    final List<Device> devices = List.from(currentState.devices);
    final List<DeviceInterface> deviceInstances =
        List.from(currentState.deviceInstances);
    if (!devices.contains(event.device)) {
      devices.add(event.device);
      final DeviceInterface deviceInterface =
          DeviceInterface.fromDevice(event.device);
      deviceInterface.init();
      deviceInstances.add(deviceInterface);
    }

    return currentState.copyWith(
      devices: devices,
      deviceInstances: deviceInstances,
    );
  }

  Future<DevicesState> _removeDeviceIfExist(RemoveDeviceEvent event) async {
    final DevicesInitialState currentState = state as DevicesInitialState;
    final List<Device> devices = List.from(currentState.devices);
    final List<DeviceInterface> deviceInstances =
        List.from(currentState.deviceInstances);
    if (devices.contains(event.device)) {
      final DeviceInterface deviceInterface =
      DeviceInterface.fromDevice(event.device);
      devices.remove(event.device);
      deviceInterface.dispose();
      deviceInstances.remove(deviceInterface);
    }
    if (!devices.contains(event.device)) {
      devices.add(event.device);
    }

    return currentState.copyWith(devices: devices);
  }
}
