import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/quick_usb/quick_usb.dart';

class DevicesBloc extends HydratedBloc<DevicesEvent, DevicesState> {
  List<DeviceInterface> get deviceInstances => state.deviceInstances;

  DevicesBloc() : super(DevicesState.empty()) {
    on<AddDeviceEvent>(_onAddDeviceEvent);
    on<RemoveDeviceEvent>(_onRemoveDeviceEvent);
    on<RestoreDevicesEvent>(_onRestoreDevices);
    on<LoadAvailableDevicesEvent>(_onLoadAvailableDevicesEvent);
    on<ReorderDevicesEvent>(_onReorderDevicesEvent);
    on<UpdateDevices>(_onUpdateDevicesEvent);
    on<UpdateDeviceOffsetEvent>(_onUpdateDeviceOffsetEvent);
    on<CheckDevicesConnectionStateEvent>(_onCheckDevicesConnectionStateEvent);

    final CheckDevicesConnectionStateEvent checkDevicesConnectionStateEvent = CheckDevicesConnectionStateEvent();
    add(checkDevicesConnectionStateEvent);
  }

  @override
  DevicesState fromJson(final Map<String, dynamic> json) {
    final DevicesState state = DevicesState.fromJson(
      json['devicesState'] as Map<String, dynamic>,
    );
    final List<DeviceData> devicesData = state.devicesData;
    return DevicesState(
      availableDevices: <DeviceData>[],
      deviceInstances: <DeviceInterface>[],
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
    final List<DeviceData> devicesData = state.devicesData;
    final List<DeviceInterface> deviceInstances = state.deviceInstances;
    final DeviceData deviceData = event.deviceData;
    final List<DeviceData> existingDevices =
        deviceInstances.map((final DeviceInterface existingDeviceData) => existingDeviceData.deviceData).toList();
    if (!existingDevices.contains(deviceData)) {
      return _addDevice(
        deviceData: deviceData,
        devicesData: devicesData,
        deviceInstances: deviceInstances,
      );
    }

    return state;
  }

  DevicesState _addDevice({
    required final DeviceData deviceData,
    required final List<DeviceData> devicesData,
    required final List<DeviceInterface> deviceInstances,
  }) {
    final List<DeviceData> devicesData = state.devicesData;
    final DeviceInterface deviceInterface = DeviceInterface.fromDeviceData(deviceData: deviceData);
    deviceInterface.init();
    deviceInstances.add(deviceInterface);
    if (!devicesData.contains(deviceData)) {
      devicesData.add(deviceData);
    }

    return state.copyWith(
      devicesData: devicesData,
      deviceInstances: deviceInstances,
    );
  }

  Future<void> _onRemoveDeviceEvent(final RemoveDeviceEvent event, final Emitter<DevicesState> emit) async {
    final DevicesState newState = _removeDeviceIfExist(event);
    emit(newState);
  }

  DevicesState _removeDeviceIfExist(final RemoveDeviceEvent event) {
    final List<DeviceData> devicesData = state.devicesData;
    final DeviceData deviceData = event.deviceData;
    final List<DeviceInterface> deviceInstances = state.deviceInstances;
    if (devicesData.contains(deviceData)) {
      return _removeDevice(deviceData, devicesData, deviceInstances);
    }

    return state.copyWith(
      devicesData: devicesData,
      deviceInstances: deviceInstances,
    );
  }

  DevicesState _removeDevice(
    final DeviceData deviceData,
    final List<DeviceData> devicesData,
    final List<DeviceInterface> deviceInstances,
  ) {
    final DeviceInterface deviceInterface = state.deviceInstances.firstWhere(
      (final DeviceInterface deviceInterface) =>
          deviceInterface.deviceData.deviceProductVendor == deviceData.deviceProductVendor,
    );
    deviceInterface.dispose();
    deviceInstances.remove(deviceInterface);
    devicesData.remove(deviceData);

    return state.copyWith(
      devicesData: devicesData,
      deviceInstances: deviceInstances,
    );
  }

  Future<void> _onRestoreDevices(
    final RestoreDevicesEvent event,
    final Emitter<DevicesState> emit,
  ) async {
    final List<DeviceData> devicesData = state.devicesData;
    for (final DeviceData deviceData in devicesData) {
      final AddDeviceEvent event = AddDeviceEvent(deviceData: deviceData);
      add(event);
    }
  }

  Future<void> _onLoadAvailableDevicesEvent(
    final LoadAvailableDevicesEvent event,
    final Emitter<DevicesState> emit,
  ) async {
    final QuickUsb quickUsb = QuickUsb();
    final List<DeviceData> deviceProductInfo = quickUsb.getDeviceProductInfo();
    final DevicesState newState = state.copyWith(availableDevices: deviceProductInfo);

    emit(newState);
  }

  Future<void> _onReorderDevicesEvent(
    final ReorderDevicesEvent event,
    final Emitter<DevicesState> emit,
  ) async {
    final int oldIndex = event.oldIndex;
    final int newIndex = event.newIndex;
    final List<DeviceData> devicesData = _replaceDeviceData(oldIndex, newIndex);

    final DevicesState newState = state.copyWith(
      devicesData: devicesData,
    );

    emit(newState);
  }

  List<DeviceData> _replaceDeviceData(final int oldIndex, final int newIndex) {
    final List<DeviceData> devicesData = state.devicesData;
    final DeviceData deviceData = devicesData.removeAt(oldIndex);
    devicesData.insert(newIndex, deviceData);

    return devicesData;
  }

  Future<void> _onUpdateDevicesEvent(final UpdateDevices event, final Emitter<DevicesState> emit) async {
    final List<DeviceData> currentConnectedDevices = state.connectedDevices;
    final List<DeviceData> connectedDevices = event.connectedDevices;
    final bool connectedDevicesChanged = listEquals(currentConnectedDevices, connectedDevices);
    if (!connectedDevicesChanged) {
      final DevicesState newState = state.copyWith(
        devicesData: event.devicesData,
        connectedDevices: connectedDevices,
        availableDevices: event.availableDevices,
      );

      emit(newState);
    }
  }

  void _onCheckDevicesConnectionStateEvent(
    final CheckDevicesConnectionStateEvent event,
    final Emitter<DevicesState> emit,
  ) {
    final QuickUsb quickUsb = QuickUsb();
    final List<DeviceData> availableDevices = quickUsb.getDeviceProductInfo();
    final List<DeviceData> devicesData = <DeviceData>[];
    final List<DeviceData> connectedDevices = <DeviceData>[];
    for (final DeviceData deviceData in state.devicesData) {
      _processDeviceConnectivity(
        availableDevices: availableDevices,
        devicesData: devicesData,
        deviceData: deviceData,
        connectedDevices: connectedDevices,
      );
    }

    final UpdateDevices updateDevices = UpdateDevices(
      devicesData: devicesData,
      connectedDevices: connectedDevices,
      availableDevices: availableDevices,
    );
    add(updateDevices);
  }

  void _processDeviceConnectivity({
    required final List<DeviceData> availableDevices,
    required final List<DeviceData> devicesData,
    required final DeviceData deviceData,
    required final List<DeviceData> connectedDevices,
  }) {
    final bool isDeviceConnected = availableDevices.contains(deviceData);
    final DeviceData updatedDevice = deviceData.copyWith(connected: isDeviceConnected);
    devicesData.add(updatedDevice);
    if (isDeviceConnected) {
      _processConnectedDevice(
        deviceData: deviceData,
        updatedDevice: updatedDevice,
        connectedDevices: connectedDevices,
      );
    }
  }

  void _processConnectedDevice({
    required final DeviceData deviceData,
    required final DeviceData updatedDevice,
    required final List<DeviceData> connectedDevices,
  }) {
    connectedDevices.add(updatedDevice);
    final DeviceInterface deviceInterface = state.deviceInstances.firstWhere(
      (final DeviceInterface connectedDevice) =>
          connectedDevice.deviceData.deviceProductVendor == updatedDevice.deviceProductVendor,
    );
    _reInitDevHandle(
      deviceInterface: deviceInterface,
      deviceData: deviceData,
    );
  }

  void _reInitDevHandle({required final DeviceInterface deviceInterface, required final DeviceData deviceData}) {
    if (!deviceData.connected) {
      deviceInterface.initDevHandle();
    }
  }

  Future<void> _onUpdateDeviceOffsetEvent(final UpdateDeviceOffsetEvent event, final Emitter<DevicesState> emit) async {
    final DeviceInterface deviceInterface = event.deviceInterface;
    final DeviceData deviceData = deviceInterface.deviceData;
    final List<DeviceInterface> deviceInstances = state.deviceInstances;
    final List<DeviceData> devicesData = state.devicesData;
    final int index = deviceInstances.indexOf(deviceInterface);
    final int offsetX = event.offsetX;
    final int offsetY = event.offsetY;
    final DeviceData updatedDeviceData = DeviceData(
      deviceProductVendor: deviceData.deviceProductVendor,
      offsetX: offsetX,
      offsetY: offsetY,
    );

    deviceInterface.deviceData = updatedDeviceData;
    devicesData[index] = updatedDeviceData;

    final DevicesState newState = state.copyWith(
      deviceInstances: deviceInstances,
      devicesData: devicesData,
    );
    emit(newState);
  }
}
