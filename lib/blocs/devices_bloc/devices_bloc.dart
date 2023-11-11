import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/quick_usb/quick_usb.dart';
import 'package:rgb_app/utils/tick_provider.dart';

class DevicesBloc extends HydratedBloc<DevicesEvent, DevicesState> {
  final TickProvider _tickProvider;

  List<DeviceInterface> get deviceInstances => state.deviceInstances;

  DevicesBloc({required TickProvider tickProvider})
      : _tickProvider = tickProvider,
        super(DevicesState.empty()) {
    on<AddDeviceEvent>(_onAddDeviceEvent);
    on<RemoveDeviceEvent>(_onRemoveDeviceEvent);
    on<RestoreDevicesEvent>(_onRestoreDevices);
    on<LoadAvailableDevicesEvent>(_onLoadAvailableDevicesEvent);
    on<ReorderDevicesEvent>(_onReorderDevicesEvent);
    on<UpdateDevices>(_onUpdateDevicesEvent);
    on<UpdateDeviceOffsetEvent>(_onUpdateDeviceOffsetEvent);
    on<CheckDevicesConnectionStateEvent>(_onCheckDevicesConnectionStateEvent);

    Future<void>.delayed(const Duration(seconds: 2), () {
      final CheckDevicesConnectionStateEvent checkDevicesConnectionStateEvent = CheckDevicesConnectionStateEvent();
      add(checkDevicesConnectionStateEvent);
    });
    _tickProvider.onTick(() {
      for (DeviceInterface device in deviceInstances) {
        device.update();
      }
    });
  }

  @override
  DevicesState fromJson(Map<String, Object?> json) {
    final DevicesState state = DevicesState.fromJson(
      json['devicesState'] as Map<String, Object?>,
    );
    final List<DeviceData> devicesData = state.devicesData;
    return DevicesState(
      availableDevices: <DeviceData>[],
      deviceInstances: <DeviceInterface>[],
      devicesData: devicesData,
    );
  }

  @override
  Map<String, Object?> toJson(DevicesState state) {
    return <String, Object?>{
      'devicesState': <String, Object?>{
        'devicesData': state.devicesData,
      },
    };
  }

  Future<void> _onAddDeviceEvent(AddDeviceEvent event, Emitter<DevicesState> emit) async {
    final DevicesState newState = _addDeviceIfNew(event);
    emit(newState);
  }

  DevicesState _addDeviceIfNew(AddDeviceEvent event) {
    final List<DeviceData> devicesData = state.devicesData;
    final List<DeviceInterface> deviceInstances = state.deviceInstances;
    final DeviceData deviceData = event.deviceData;
    final List<DeviceData> existingDevices =
    deviceInstances.map((DeviceInterface existingDeviceData) => existingDeviceData.deviceData).toList();
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
    required DeviceData deviceData,
    required List<DeviceData> devicesData,
    required List<DeviceInterface> deviceInstances,
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

  Future<void> _onRemoveDeviceEvent(RemoveDeviceEvent event, Emitter<DevicesState> emit) async {
    final DevicesState newState = _removeDeviceIfExist(event);
    emit(newState);
  }

  DevicesState _removeDeviceIfExist(RemoveDeviceEvent event) {
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

  DevicesState _removeDevice(final DeviceData deviceData,
      final List<DeviceData> devicesData,
      final List<DeviceInterface> deviceInstances,) {
    final DeviceInterface deviceInterface = state.deviceInstances.firstWhere(
          (DeviceInterface deviceInterface) =>
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

  Future<void> _onRestoreDevices(final RestoreDevicesEvent event,
      final Emitter<DevicesState> emit,) async {
    final List<DeviceData> devicesData = state.devicesData;
    for (DeviceData deviceData in devicesData) {
      final AddDeviceEvent event = AddDeviceEvent(deviceData: deviceData);
      add(event);
    }
  }

  Future<void> _onLoadAvailableDevicesEvent(final LoadAvailableDevicesEvent event,
      final Emitter<DevicesState> emit,) async {
    final QuickUsb quickUsb = QuickUsb();
    final List<DeviceData> deviceProductInfo = quickUsb.getDeviceProductInfo();
    final DevicesState newState = state.copyWith(availableDevices: deviceProductInfo);

    emit(newState);
  }

  Future<void> _onReorderDevicesEvent(final ReorderDevicesEvent event,
      final Emitter<DevicesState> emit,) async {
    final int oldIndex = event.oldIndex;
    final int newIndex = event.newIndex;
    final List<DeviceData> devicesData = _replaceDeviceData(oldIndex, newIndex);

    final DevicesState newState = state.copyWith(
      devicesData: devicesData,
    );

    emit(newState);
  }

  List<DeviceData> _replaceDeviceData(int oldIndex, int newIndex) {
    final List<DeviceData> devicesData = state.devicesData;
    final DeviceData deviceData = devicesData.removeAt(oldIndex);
    devicesData.insert(newIndex, deviceData);

    return devicesData;
  }

  Future<void> _onUpdateDevicesEvent(UpdateDevices event, Emitter<DevicesState> emit) async {
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

  void _onCheckDevicesConnectionStateEvent(final CheckDevicesConnectionStateEvent event,
      final Emitter<DevicesState> emit,) {
    final QuickUsb quickUsb = QuickUsb();
    final List<DeviceData> availableDevices = quickUsb.getDeviceProductInfo();
    final List<DeviceData> devicesData = <DeviceData>[];
    final List<DeviceData> connectedDevices = <DeviceData>[];
    for (DeviceData deviceData in state.devicesData) {
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
    required List<DeviceData> availableDevices,
    required List<DeviceData> devicesData,
    required DeviceData deviceData,
    required List<DeviceData> connectedDevices,
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
    required DeviceData deviceData,
    required DeviceData updatedDevice,
    required List<DeviceData> connectedDevices,
  }) {
    connectedDevices.add(updatedDevice);
    final DeviceInterface deviceInterface = state.deviceInstances.firstWhere(
          (DeviceInterface connectedDevice) =>
          connectedDevice.deviceData.deviceProductVendor == updatedDevice.deviceProductVendor,
    );
    _reInitDevHandle(
      deviceInterface: deviceInterface,
      deviceData: deviceData,
    );
  }

  void _reInitDevHandle({required DeviceInterface deviceInterface, required DeviceData deviceData}) {
    if (!deviceData.connected) {
      deviceInterface.initDevHandle();
    }
  }

  Future<void> _onUpdateDeviceOffsetEvent(UpdateDeviceOffsetEvent event, Emitter<DevicesState> emit) async {
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
