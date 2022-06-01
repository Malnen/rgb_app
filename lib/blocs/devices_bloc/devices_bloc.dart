import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/cubits/devices_cubit.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:rgb_app/models/device_data.dart';

import '../../devices/device.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  final DevicesCubit _devicesCubit;

  DevicesBloc({required List<Device> availableDevices})
      : _devicesCubit = DevicesCubit(),
        super(DevicesState(
          devices: [],
          availableDevices: availableDevices,
          deviceInstances: [],
        )) {
    on<AddDeviceEvent>(_onAddDeviceEvent);
    on<RemoveDeviceEvent>(_onRemoveDeviceEvent);
    on<RestoreDevicesEvent>(_onRestoreDevices);
  }

  Future<void> _onAddDeviceEvent(
      AddDeviceEvent event, Emitter<DevicesState> emit) async {
    _addDeviceIfNew(event).then((DevicesState state) => emit(state));
  }

  Future<void> _onRemoveDeviceEvent(
      RemoveDeviceEvent event, Emitter<DevicesState> emit) async {
    _removeDeviceIfExist(event).then((DevicesState state) => emit(state));
  }

  Future<DevicesState> _addDeviceIfNew(AddDeviceEvent event) async {
    final List<Device> devices = state.devices;
    final List<DeviceInterface> deviceInstances = state.deviceInstances;
    final Device device = event.device;
    if (!devices.contains(device)) {
      _addDevice(
        device,
        devices,
        deviceInstances,
        event.keyBloc,
      );
    }

    return state.copyWith(
      devices: devices,
      deviceInstances: deviceInstances,
    );
  }

  void _addDevice(
    Device device,
    List<Device> devices,
    List<DeviceInterface> deviceInstances,
    KeyBloc? keyBloc,
  ) {
    devices.add(device);
    final DeviceInterface deviceInterface = DeviceInterface.fromDevice(
      device: device,
      keyBloc: keyBloc,
    );
    final DeviceData deviceData = DeviceData(
      deviceProductVendor: device.deviceProductVendor,
    );
    deviceInterface.init();
    deviceInstances.add(deviceInterface);
    _devicesCubit.addDeviceData(deviceData);
  }

  Future<DevicesState> _removeDeviceIfExist(RemoveDeviceEvent event) async {
    final List<Device> devices = state.devices;
    final Device device = event.device;
    final List<DeviceInterface> deviceInstances = state.deviceInstances;
    if (devices.contains(device)) {
      _removeDevice(device, devices, deviceInstances);
    }

    return state.copyWith(
      devices: devices,
      deviceInstances: deviceInstances,
    );
  }

  void _removeDevice(
    Device device,
    List<Device> devices,
    List<DeviceInterface> deviceInstances,
  ) {
    final DeviceInterface deviceInterface =
        DeviceInterface.fromDevice(device: device);
    final DeviceData deviceData = DeviceData(
      deviceProductVendor: device.deviceProductVendor,
    );
    devices.remove(device);
    deviceInterface.dispose();
    deviceInstances.remove(deviceInterface);
    _devicesCubit.removeDeviceData(deviceData);
  }

  Future<void> _onRestoreDevices(
    RestoreDevicesEvent event,
    Emitter<DevicesState> emit,
  ) async {
    final List<Device> devices = [];
    for (Device device in state.availableDevices) {
      _addDeviceToRestore(device, devices);
    }

    final DevicesState newState = state.copyWith(
      devices: devices,
    );
    emit(newState);
  }

  void _addDeviceToRestore(Device device, List<Device> devices) {
    final DeviceProductVendor deviceProductVendor = device.deviceProductVendor;
    final bool hasAny = _devicesCubit.state.any((DeviceData deviceData) =>
        deviceData.deviceProductVendor.productVendor == deviceProductVendor.productVendor);
    if (hasAny) {
      devices.add(device);
    }
  }
}
