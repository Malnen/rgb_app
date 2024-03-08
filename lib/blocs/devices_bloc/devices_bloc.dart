import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/utils/tick_provider.dart';
import 'package:rgb_app/utils/usb_device_change/usb_device_change_detector.dart';
import 'package:rgb_app/utils/usb_device_data_sender/usb_device_data_sender.dart';
import 'package:rgb_app/utils/usb_devices_info_getter/usb_devices_info_getter.dart';

class DevicesBloc extends HydratedBloc<DevicesEvent, DevicesState> {
  final TickProvider _tickProvider;

  late final UsbDeviceChangeDetector usbDeviceChangeDetector;
  late final UsbDeviceInfoGetter usbDeviceInfoGetter;
  late final UsbDeviceDataSender usbDeviceDataSender;

  List<DeviceInterface> get deviceInstances => state.deviceInstances;

  DevicesBloc({required TickProvider tickProvider})
      : _tickProvider = tickProvider,
        super(DevicesState.empty()) {
    on<AddDeviceEvent>(_onAddDeviceEvent, transformer: concurrent());
    on<RemoveDeviceEvent>(_onRemoveDeviceEvent);
    on<RestoreDevicesEvent>(_onRestoreDevices);
    on<LoadAvailableDevicesEvent>(_onLoadAvailableDevicesEvent);
    on<ReorderDevicesEvent>(_onReorderDevicesEvent);
    on<UpdateDevices>(_onUpdateDevicesEvent);
    on<UpdateDeviceOffsetEvent>(_onUpdateDeviceOffsetEvent);
    on<CheckDevicesConnectionStateEvent>(_onCheckDevicesConnectionStateEvent);
    on<SendDataManuallyEvent>(_onSendDataManually);
  }

  Future<void> init() async {
    usbDeviceInfoGetter = UsbDeviceInfoGetter();
    usbDeviceChangeDetector = UsbDeviceChangeDetector(() => add(CheckDevicesConnectionStateEvent()));
    usbDeviceDataSender = UsbDeviceDataSender();
    await Future.wait(<Future<void>>[
      usbDeviceInfoGetter.init(),
      usbDeviceChangeDetector.init(),
      usbDeviceDataSender.init(),
    ]);
    Future<void>.delayed(const Duration(seconds: 5), () {
      final CheckDevicesConnectionStateEvent checkDevicesConnectionStateEvent = CheckDevicesConnectionStateEvent();
      add(checkDevicesConnectionStateEvent);
    });
    _tickProvider.onTick(() {
      for (DeviceInterface device in deviceInstances) {
        device.update();
        usbDeviceDataSender.sendData(device);
      }
    });
  }

  @override
  DevicesState fromJson(Map<String, Object?> json) => DevicesState.fromJsonWithModifiableLists(json);

  @override
  Map<String, Object?> toJson(DevicesState state) => state.toJson();

  Future<void> _onAddDeviceEvent(AddDeviceEvent event, Emitter<DevicesState> emit) async {
    final DevicesState newState = await _addDeviceIfNew(event);
    emit(newState);
  }

  Future<DevicesState> _addDeviceIfNew(AddDeviceEvent event) async {
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

  Future<DevicesState> _addDevice({
    required DeviceData deviceData,
    required List<DeviceData> devicesData,
    required List<DeviceInterface> deviceInstances,
  }) async {
    final List<DeviceData> devicesData = state.devicesData;
    final DeviceInterface deviceInterface = DeviceInterface.fromDeviceData(deviceData: deviceData);
    usbDeviceDataSender.openDevice(deviceInterface);
    await deviceInterface.isOpen.first;
    deviceInterface.init();
    deviceInstances.add(deviceInterface);
    if (!devicesData.contains(deviceData)) {
      devicesData.add(deviceData);
    }

    return state.copyWith(
      devicesData: devicesData,
      deviceInstances: deviceInstances,
      key: UniqueKey(),
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
      key: UniqueKey(),
    );
  }

  DevicesState _removeDevice(
    final DeviceData deviceData,
    final List<DeviceData> devicesData,
    final List<DeviceInterface> deviceInstances,
  ) {
    final DeviceInterface deviceInterface = state.deviceInstances.firstWhere(
      (DeviceInterface deviceInterface) =>
          deviceInterface.deviceData.deviceProductVendor == deviceData.deviceProductVendor,
    );
    usbDeviceDataSender.closeDevice(deviceInterface);
    deviceInterface.dispose();
    deviceInstances.remove(deviceInterface);
    devicesData.remove(deviceData);

    return state.copyWith(
      devicesData: devicesData,
      deviceInstances: deviceInstances,
      key: UniqueKey(),
    );
  }

  Future<void> _onRestoreDevices(
    final RestoreDevicesEvent event,
    final Emitter<DevicesState> emit,
  ) async {
    final List<DeviceData> devicesData = state.devicesData;
    for (DeviceData deviceData in devicesData) {
      final AddDeviceEvent event = DevicesEvent.addDevice(deviceData) as AddDeviceEvent;
      add(event);
    }
  }

  Future<void> _onLoadAvailableDevicesEvent(
    final LoadAvailableDevicesEvent event,
    final Emitter<DevicesState> emit,
  ) async {
    final List<DeviceData> deviceProductInfo = await usbDeviceInfoGetter.getDeviceProductInfo();
    final DevicesState newState = state.copyWith(
      availableDevices: deviceProductInfo,
      key: UniqueKey(),
    );

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
      key: UniqueKey(),
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
        key: UniqueKey(),
      );

      emit(newState);
    }
  }

  Future<void> _onCheckDevicesConnectionStateEvent(
    CheckDevicesConnectionStateEvent event,
    Emitter<DevicesState> emit,
  ) async {
    final List<DeviceData> availableDevices = await usbDeviceInfoGetter.getDeviceProductInfo();
    final List<DeviceData> devicesData = <DeviceData>[];
    final List<DeviceData> connectedDevices = <DeviceData>[];
    for (DeviceData deviceData in state.devicesData) {
      await _processDeviceConnectivity(
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
    if (availableDevices.length != state.availableDevices.length) {
      add(LoadAvailableDevicesEvent());
    }
  }

  Future<void> _processDeviceConnectivity({
    required List<DeviceData> availableDevices,
    required List<DeviceData> devicesData,
    required DeviceData deviceData,
    required List<DeviceData> connectedDevices,
  }) async {
    final bool isDeviceConnected = availableDevices
        .map((DeviceData deviceData) => deviceData.deviceProductVendor.productVendor)
        .contains(deviceData.deviceProductVendor.productVendor);
    final DeviceData updatedDevice = deviceData.copyWith(connected: isDeviceConnected);
    devicesData.add(updatedDevice);
    if (isDeviceConnected) {
      await _processConnectedDevice(
        deviceData: deviceData,
        updatedDevice: updatedDevice,
        connectedDevices: connectedDevices,
      );
    }
  }

  Future<void> _processConnectedDevice({
    required DeviceData deviceData,
    required DeviceData updatedDevice,
    required List<DeviceData> connectedDevices,
  }) async {
    connectedDevices.add(updatedDevice);
    final DeviceInterface deviceInterface = state.deviceInstances.firstWhere(
      (DeviceInterface connectedDevice) =>
          connectedDevice.deviceData.deviceProductVendor == updatedDevice.deviceProductVendor,
    );
    await _reInitDevHandle(
      deviceInterface: deviceInterface,
      deviceData: deviceData,
    );
  }

  Future<void> _reInitDevHandle({required DeviceInterface deviceInterface, required DeviceData deviceData}) async {
    if (!deviceData.connected) {
      usbDeviceDataSender.closeDevice(deviceInterface);
      usbDeviceDataSender.openDevice(deviceInterface);
      await deviceInterface.isOpen.stream.firstWhere((bool value) => value);
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
      key: UniqueKey(),
    );
    emit(newState);
  }

  Future<void> _onSendDataManually(
    SendDataManuallyEvent event,
    Emitter<DevicesState> emit,
  ) async {
    usbDeviceDataSender.sendData(event.deviceInterface);
  }
}
