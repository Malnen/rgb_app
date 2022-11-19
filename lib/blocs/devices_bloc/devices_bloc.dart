import 'dart:async';

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/quick_usb/quick_usb.dart';

import '../../devices/device.dart';

class DevicesBloc extends HydratedBloc<DevicesEvent, DevicesState> {
  List<DeviceInterface> get deviceInstances => state.deviceInstances;

  DevicesBloc() : super(DevicesState.empty()) {
    on<AddDeviceEvent>(_onAddDeviceEvent);
    on<RemoveDeviceEvent>(_onRemoveDeviceEvent);
    on<RestoreDevicesEvent>(_onRestoreDevices);
    on<LoadAvailableDevicesEvent>(_onLoadAvailableDevicesEvent);
  }

  @override
  DevicesState fromJson(Map<String, dynamic> json) {
    final DevicesState state = DevicesState.fromJson(
      json['devicesState'] as Map<String, dynamic>,
    );
    final List<DeviceData> devicesData = state.devicesData;
    return DevicesState(
      availableDevices: [],
      deviceInstances: [],
      devices: [],
      devicesData: devicesData,
    );
  }

  @override
  Map<String, dynamic> toJson(DevicesState state) {
    return {
      'devicesState': <String, dynamic>{
        'devicesData': state.devicesData,
      }
    };
  }

  Future<void> _onAddDeviceEvent(AddDeviceEvent event, Emitter<DevicesState> emit) async {
    final DevicesState newState = _addDeviceIfNew(event);
    emit(newState);
  }

  DevicesState _addDeviceIfNew(AddDeviceEvent event) {
    final List<Device> devices = state.devices;
    final List<DeviceInterface> deviceInstances = state.deviceInstances;
    final Device device = event.device;
    if (!devices.contains(device)) {
      return _addDevice(
        device,
        devices,
        deviceInstances,
      );
    }

    return state.copyWith(
      devices: devices,
      deviceInstances: deviceInstances,
    );
  }

  DevicesState _addDevice(
    Device device,
    List<Device> devices,
    List<DeviceInterface> deviceInstances,
  ) {
    devices.add(device);
    final DeviceInterface deviceInterface = DeviceInterface.fromDevice(device: device);
    final DeviceData deviceData = DeviceData(deviceProductVendor: device.deviceProductVendor);
    deviceInterface.init();
    deviceInstances.add(deviceInterface);
    final List<DeviceData> devicesData = state.devicesData;
    devicesData.add(deviceData);

    return state.copyWith(
      devicesData: devicesData,
      devices: devices,
      deviceInstances: deviceInstances,
    );
  }

  Future<void> _onRemoveDeviceEvent(RemoveDeviceEvent event, Emitter<DevicesState> emit) async {
    final DevicesState newState = _removeDeviceIfExist(event);
    emit(newState);
  }

  DevicesState _removeDeviceIfExist(RemoveDeviceEvent event) {
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

  DevicesState _removeDevice(
    Device device,
    List<Device> devices,
    List<DeviceInterface> deviceInstances,
  ) {
    final DeviceInterface deviceInterface = state.deviceInstances.firstWhere(
        (DeviceInterface deviceInterface) => deviceInterface.device.deviceProductVendor == device.deviceProductVendor);
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
    RestoreDevicesEvent event,
    Emitter<DevicesState> emit,
  ) async {
    final List<Device> devices = [];
    for (Device device in state.availableDevices) {
      _addDeviceToRestore(device, devices);
    }

    final DevicesState newState = state.copyWith(devices: devices);
    emit(newState);
  }

  void _addDeviceToRestore(Device device, List<Device> devices) {
    final DeviceProductVendor deviceProductVendor = device.deviceProductVendor;
    final List<DeviceData> devicesData = state.devicesData;
    final bool hasAny = devicesData.any((DeviceData deviceData) =>
        deviceData.deviceProductVendor.productVendor == deviceProductVendor.productVendor &&
        deviceData.deviceProductVendor is! UnknownProductVendor);
    if (hasAny) {
      final AddDeviceEvent event = AddDeviceEvent(device: device);
      add(event);
    }
  }

  Future<void> _onLoadAvailableDevicesEvent(
    LoadAvailableDevicesEvent event,
    Emitter<DevicesState> emit,
  ) async {
    final QuickUsb quickUsb = QuickUsb();
    final List<Device> deviceProductInfo = quickUsb.getDeviceProductInfo();
    final newState = state.copyWith(availableDevices: deviceProductInfo);

    emit(newState);
  }
}
