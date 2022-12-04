import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/devices/device.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/quick_usb/quick_usb.dart';

class DevicesBloc extends HydratedBloc<DevicesEvent, DevicesState> {
  List<DeviceInterface> get deviceInstances => state.deviceInstances;

  DevicesBloc() : super(DevicesState.empty()) {
    on<AddDeviceEvent>(
      _onAddDeviceEvent,
    );
    on<RemoveDeviceEvent>(_onRemoveDeviceEvent);
    on<RestoreDevicesEvent>(_onRestoreDevices);
    on<LoadAvailableDevicesEvent>(_onLoadAvailableDevicesEvent);
    on<ReorderDevicesEvent>(_onReorderDevicesEvent);
    on<UpdateDevices>(_onUpdateDevicesEvent);

    _checkDevicesState();
    Timer.periodic(Duration(seconds: 5), (final Timer timer) => _checkDevicesState());
  }

  @override
  DevicesState fromJson(final Map<String, dynamic> json) {
    final DevicesState state = DevicesState.fromJson(
      json['devicesState'] as Map<String, dynamic>,
    );
    final List<DeviceData> devicesData = state.devicesData;
    return DevicesState(
      availableDevices: <Device>[],
      deviceInstances: <DeviceInterface>[],
      devices: <Device>[],
      devicesData: devicesData,
    );
  }

  @override
  Map<String, dynamic> toJson(final DevicesState state) {
    return <String, dynamic>{
      'devicesState': <String, dynamic>{
        'devicesData': state.devicesData,
      }
    };
  }

  Future<void> _onAddDeviceEvent(final AddDeviceEvent event, final Emitter<DevicesState> emit) async {
    final DevicesState newState = _addDeviceIfNew(event);
    emit(newState);
  }

  DevicesState _addDeviceIfNew(final AddDeviceEvent event) {
    final List<Device> devices = state.devices;
    final List<DeviceInterface> deviceInstances = state.deviceInstances;
    final Device device = event.device;
    if (!devices.contains(device)) {
      return _addDevice(
        device: device,
        devices: devices,
        deviceInstances: deviceInstances,
      );
    }

    return state;
  }

  DevicesState _addDevice({
    required final Device device,
    required final List<Device> devices,
    required final List<DeviceInterface> deviceInstances,
  }) {
    final List<Device> devices = state.devices;
    devices.add(device);
    final DeviceInterface deviceInterface = DeviceInterface.fromDevice(device: device);
    deviceInterface.init();
    deviceInstances.add(deviceInterface);
    final List<DeviceData> devicesData = state.devicesData;
    final DeviceData deviceData = DeviceData(deviceProductVendor: device.deviceProductVendor);
    if (!devicesData.contains(deviceData)) {
      devicesData.add(deviceData);
    }

    return state.copyWith(
      devicesData: devicesData,
      devices: devices,
      deviceInstances: deviceInstances,
    );
  }

  Future<void> _onRemoveDeviceEvent(final RemoveDeviceEvent event, final Emitter<DevicesState> emit) async {
    final DevicesState newState = _removeDeviceIfExist(event);
    emit(newState);
  }

  DevicesState _removeDeviceIfExist(final RemoveDeviceEvent event) {
    final List<Device> devices = state.devices;
    final Device device = event.device;
    final List<DeviceInterface> deviceInstances = state.deviceInstances;
    if (devices.contains(device)) {
      return _removeDevice(device, devices, deviceInstances);
    }

    return state.copyWith(
      devices: devices,
      deviceInstances: deviceInstances,
    );
  }

  DevicesState _removeDevice(final Device device, final List<Device> devices, final List<DeviceInterface> deviceInstances) {
    final DeviceInterface deviceInterface = state.deviceInstances.firstWhere(
        (final DeviceInterface deviceInterface) => deviceInterface.device.deviceProductVendor == device.deviceProductVendor);
    final DeviceData deviceData = DeviceData(
      deviceProductVendor: device.deviceProductVendor,
    );
    deviceInterface.dispose();
    devices.remove(device);
    deviceInstances.remove(deviceInterface);
    final List<DeviceData> devicesData = state.devicesData;
    devicesData.remove(deviceData);

    return state.copyWith(
      devicesData: devicesData,
      devices: devices,
      deviceInstances: deviceInstances,
    );
  }

  Future<void> _onRestoreDevices(
    final RestoreDevicesEvent event,
    final Emitter<DevicesState> emit,
  ) async {
    final List<DeviceData> devicesData = state.devicesData;
    for (final DeviceData deviceData in devicesData) {
      final Device device = Device.fromDeviceData(deviceData);
      final AddDeviceEvent event = AddDeviceEvent(device: device);
      add(event);
    }
  }

  Future<void> _onLoadAvailableDevicesEvent(
    final LoadAvailableDevicesEvent event,
    final Emitter<DevicesState> emit,
  ) async {
    final QuickUsb quickUsb = QuickUsb();
    final List<Device> deviceProductInfo = quickUsb.getDeviceProductInfo();
    final DevicesState newState = state.copyWith(availableDevices: deviceProductInfo);

    emit(newState);
  }

  Future<void> _onReorderDevicesEvent(
    final ReorderDevicesEvent event,
    final Emitter<DevicesState> emit,
  ) async {
    final int oldIndex = event.oldIndex;
    final int newIndex = event.newIndex;
    final List<Device> devices = _replaceDevice(oldIndex, newIndex);
    final List<DeviceData> devicesData = _replaceDeviceData(oldIndex, newIndex);

    final DevicesState newState = state.copyWith(
      devices: devices,
      devicesData: devicesData,
    );

    emit(newState);
  }

  List<Device> _replaceDevice(final int oldIndex, final int newIndex) {
    final List<Device> devices = state.devices;
    final Device device = devices.removeAt(oldIndex);
    devices.insert(newIndex, device);

    return devices;
  }

  List<DeviceData> _replaceDeviceData(final int oldIndex, final int newIndex) {
    final List<DeviceData> devicesData = state.devicesData;
    final DeviceData deviceData = devicesData.removeAt(oldIndex);
    devicesData.insert(newIndex, deviceData);

    return devicesData;
  }

  Future<void> _onUpdateDevicesEvent(final UpdateDevices event, final Emitter<DevicesState> emit) async {
    final List<Device> currentConnectedDevices = state.connectedDevices;
    final List<Device> connectedDevices = event.connectedDevices;
    final bool connectedDevicesChanged = listEquals(currentConnectedDevices, connectedDevices);
    if (!connectedDevicesChanged) {
      final DevicesState newState = state.copyWith(
        devices: event.devices,
        connectedDevices: connectedDevices,
        availableDevices: event.availableDevices,
      );

      emit(newState);
    }
  }

  void _checkDevicesState() {
    final QuickUsb quickUsb = QuickUsb();
    final List<Device> availableDevices = quickUsb.getDeviceProductInfo();
    final List<Device> devices = <Device>[];
    final List<Device> connectedDevices = <Device>[];
    for (final Device device in state.devices) {
      _processDeviceConnectivity(
        availableDevices: availableDevices,
        devices: devices,
        device: device,
        connectedDevices: connectedDevices,
      );
    }

    final UpdateDevices updateDevices = UpdateDevices(
      devices: devices,
      connectedDevices: connectedDevices,
      availableDevices: availableDevices,
    );
    add(updateDevices);
  }

  void _processDeviceConnectivity({
    required final List<Device> availableDevices,
    required final List<Device> devices,
    required final Device device,
    required final List<Device> connectedDevices,
  }) {
    final bool isDeviceConnected = availableDevices.contains(device);
    final Device updatedDevice = device.copyWith(connected: isDeviceConnected);
    devices.add(updatedDevice);
    if (isDeviceConnected) {
      _processConnectedDevice(
        device: device,
        updatedDevice: updatedDevice,
        connectedDevices: connectedDevices,
      );
    }
  }

  void _processConnectedDevice({
    required final Device device,
    required final Device updatedDevice,
    required final List<Device> connectedDevices,
  }) {
    connectedDevices.add(updatedDevice);
    final DeviceInterface deviceInterface = state.deviceInstances.firstWhere((final DeviceInterface connectedDevice) =>
        connectedDevice.device.deviceProductVendor == updatedDevice.deviceProductVendor);
    _reInitDevHandle(
      deviceInterface: deviceInterface,
      device: device,
    );
  }

  void _reInitDevHandle({required final DeviceInterface deviceInterface, required final Device device}) {
    if (!device.connected) {
      deviceInterface.initDevHandle();
    }
  }
}
