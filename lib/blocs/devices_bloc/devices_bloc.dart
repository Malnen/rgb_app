import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/devices/corsair_icue_link_hub/corsair_icue_link_hub.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/lightning_controller_interface.dart';
import 'package:rgb_app/devices/smbus/kingston/kingston_fury_ram_detector.dart';
import 'package:rgb_app/devices/smbus/models/smbus_transaction_data.dart';
import 'package:rgb_app/devices/smbus/smbus_device_interface.dart';
import 'package:rgb_app/devices/sub_device_interface.dart';
import 'package:rgb_app/devices/udp_network_device_interface.dart';
import 'package:rgb_app/devices/usb_device_interface.dart';
import 'package:rgb_app/main.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/udp_network_device_details.dart';
import 'package:rgb_app/services/loading_service.dart';
import 'package:rgb_app/services/udp_network_service.dart';
import 'package:rgb_app/utils/smbus/smbus.dart';
import 'package:rgb_app/utils/smbus/smbus_batch_sender.dart';
import 'package:rgb_app/utils/tick_provider.dart';
import 'package:rgb_app/utils/usb_device_change/usb_device_change_detector.dart';
import 'package:rgb_app/utils/usb_device_data_sender/usb_device_data_sender.dart';
import 'package:rgb_app/utils/usb_devices_info_getter/usb_devices_info_getter.dart';

class DevicesBloc extends HydratedBloc<DevicesEvent, DevicesState> {
  final TickProvider _tickProvider;

  late final UsbDeviceChangeDetector usbDeviceChangeDetector;
  late final UsbDeviceInfoGetter usbDeviceInfoGetter;
  late final UsbDeviceDataSender usbDeviceDataSender;
  late final Smbus smbus;
  late final SMBusBatchSender smbusBatchSender;
  late final UdpNetworkService udpNetworkService;

  late final List<SMBusDeviceData> smbusDevices;

  List<DeviceInterface> get deviceInstances => state.deviceInstances;

  DevicesBloc({required TickProvider tickProvider})
      : _tickProvider = tickProvider,
        super(DevicesState.empty()) {
    on<DevicesEvent>(_onEvent, transformer: sequential());
  }

  Future<void> init() async {
    usbDeviceInfoGetter = UsbDeviceInfoGetter();
    usbDeviceChangeDetector = UsbDeviceChangeDetector(() => add(CheckUSBDevicesConnectionStateEvent()));
    usbDeviceDataSender = UsbDeviceDataSender();
    smbus = Smbus();
    smbusBatchSender = SMBusBatchSender(smbus);
    await Future.wait(<Future<void>>[
      usbDeviceInfoGetter.init(),
      usbDeviceChangeDetector.init(),
      usbDeviceDataSender.init(),
      smbus.init(),
    ]);
    final KingstonFuryRamDetector detector = KingstonFuryRamDetector(smbus);
    smbusDevices = await detector.scan();
    udpNetworkService = GetIt.instance.get();
    udpNetworkService.startDiscovery();

    Future<void>.delayed(const Duration(seconds: 5), () {
      final CheckUSBDevicesConnectionStateEvent checkDevicesConnectionStateEvent =
          CheckUSBDevicesConnectionStateEvent();
      add(checkDevicesConnectionStateEvent);
    });
    _tickProvider.onTick(
      () async {
        for (DeviceInterface device in deviceInstances) {
          device.update();
          if (device is UdpNetworkDeviceInterface) {
            device.sendData();
          }
        }

        final List<SMBusTransactionData> smbusData = deviceInstances
            .whereType<SMBusDeviceInterface>()
            .map((SMBusDeviceInterface device) => device.colorData)
            .toList();
        smbusBatchSender.send(smbusData);

        final List<Map<String, Object?>> usbData = deviceInstances
            .whereType<UsbDeviceInterface>()
            .where((UsbDeviceInterface element) => element is CorsairICueLinkHub ? element.ready : true)
            .where((UsbDeviceInterface element) => element.isOpen.valueOrNull ?? false)
            .map((UsbDeviceInterface device) => device.getPayload())
            .toList();
        unawaited(usbDeviceDataSender.sendData(usbData));
      },
    );
  }

  @override
  DevicesState fromJson(Map<String, Object?> json) => DevicesState.fromJsonWithModifiableLists(json);

  @override
  Map<String, Object?> toJson(DevicesState state) => state.toJson();

  Future<void> _onEvent(DevicesEvent event, Emitter<DevicesState> emit) async {
    await appReady.future;
    switch (event.runtimeType) {
      case const (AddDeviceEvent):
        await _onAddDeviceEvent(event as AddDeviceEvent, emit);
        break;
      case const (RemoveDeviceEvent):
        await _onRemoveDeviceEvent(event as RemoveDeviceEvent, emit);
        break;
      case const (RestoreDevicesEvent):
        await _onRestoreDevices(event as RestoreDevicesEvent, emit);
        break;
      case const (LoadAvailableDevicesEvent):
        await _onLoadAvailableDevicesEvent(event as LoadAvailableDevicesEvent, emit);
        break;
      case const (AddAvailableDeviceEvent):
        await _onAddAvailableDeviceEvent(event as AddAvailableDeviceEvent, emit);
        break;
      case const (ReorderDevicesEvent):
        await _onReorderDevicesEvent(event as ReorderDevicesEvent, emit);
        break;
      case const (UpdateDevices):
        await _onUpdateDevicesEvent(event as UpdateDevices, emit);
        break;
      case const (UpdateDeviceProperties):
        await _onUpdateDevicePropertiesEvent(event as UpdateDeviceProperties, emit);
        break;
      case const (CheckUSBDevicesConnectionStateEvent):
        await _onCheckUSBDevicesConnectionStateEvent(event as CheckUSBDevicesConnectionStateEvent, emit);
        break;
      case const (DeviceConnectionChange):
        await _onDeviceConnectionChange(event as DeviceConnectionChange, emit);
        break;
      case const (SendDataManuallyEvent):
        await _onSendDataManually(event as SendDataManuallyEvent, emit);
        break;
      case const (SelectDevicesEvent):
        await _onSelectDeviceEvent(event as SelectDevicesEvent, emit);
        break;
      case const (UpdateDeviceDataEvent):
        await _onUpdateDeviceDataEvent(event as UpdateDeviceDataEvent, emit);
        break;
      default:
        throw UnimplementedError('Event not implemented: $event');
    }
  }

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
    final DeviceInterface deviceInterface =
        DeviceInterface.fromDeviceData(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender, smbus: smbus);
    loadingService.showLoading();
    if (deviceInterface is UsbDeviceInterface) {
      await usbDeviceDataSender.openDevice(deviceInterface).timeout(Duration(seconds: 10));
    }

    loadingService.hideLoading();
    await deviceInterface.init();
    deviceInterface.updatePropertiesDeviceData();
    deviceInstances.add(deviceInterface);
    final bool contained =
        devicesData.any((DeviceData existingDeviceData) => existingDeviceData.isSameDevice(deviceData));
    if (!contained) {
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
    final List<DeviceData> devicesData = <DeviceData>[...state.devicesData];
    final DeviceData deviceData = event.deviceData;
    final List<DeviceInterface> deviceInstances = <DeviceInterface>[...state.deviceInstances];
    final bool hasDevice = devicesData.any((DeviceData device) => device.isSameDevice(deviceData));
    if (hasDevice) {
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
    final DeviceInterface? deviceInterface = state.deviceInstances
        .firstWhereOrNull((DeviceInterface deviceInterface) => deviceData.isSameDevice(deviceInterface.deviceData));
    if (deviceInterface != null) {
      if (deviceInterface is UsbDeviceInterface) {
        usbDeviceDataSender.closeDevice(deviceInterface);
      }

      deviceInterface.dispose();
    }

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
    for (final DeviceData deviceData in devicesData) {
      if (deviceData is UdpNetworkDeviceData) {
        final String targetId = deviceData.udpNetworkDeviceDetails.id;
        unawaited(
          udpNetworkService.discoveredDevices
              .firstWhere((UdpNetworkDeviceData device) => device.udpNetworkDeviceDetails.id == targetId)
              .then((UdpNetworkDeviceData matchedDevice) {
            final UdpNetworkDeviceDetails matchedUdpNetworkDeviceDetails = matchedDevice.udpNetworkDeviceDetails;
            final UdpNetworkDeviceDetails udpNetworkDeviceDetails = deviceData.udpNetworkDeviceDetails;
            final UdpNetworkDeviceData updatedDeviceData = deviceData.copyWith(
              udpNetworkDeviceDetails: udpNetworkDeviceDetails.copyWith(
                address: matchedUdpNetworkDeviceDetails.address,
                port: matchedUdpNetworkDeviceDetails.port,
              ),
            );
            add(AddDeviceEvent(updatedDeviceData));
          }),
        );
      } else {
        add(AddDeviceEvent(deviceData));
      }
    }
  }

  Future<void> _onLoadAvailableDevicesEvent(
    final LoadAvailableDevicesEvent event,
    final Emitter<DevicesState> emit,
  ) async {
    final List<Future<List<DeviceData>>> futures = <Future<List<DeviceData>>>[
      usbDeviceInfoGetter.getDeviceProductInfo(),
    ];
    final List<DeviceData> deviceProductInfo = await Future.wait(futures)
        .then((List<List<DeviceData>> results) => results.expand((List<DeviceData> list) => list).toList());
    deviceProductInfo.addAll(smbusDevices);
    final DevicesState newState = state.copyWith(
      availableDevices: deviceProductInfo,
      key: UniqueKey(),
    );

    emit(newState);
  }

  Future<void> _onAddAvailableDeviceEvent(
    final AddAvailableDeviceEvent event,
    final Emitter<DevicesState> emit,
  ) async {
    final List<DeviceData> availableDevices = state.availableDevices;
    final DeviceData deviceData = event.deviceData;
    if (!availableDevices.contains(deviceData)) {
      availableDevices.add(deviceData);
      final DevicesState newState = state.copyWith(
        availableDevices: availableDevices,
        key: UniqueKey(),
      );

      emit(newState);
    }
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
    final DevicesState newState = state.copyWith(
      devicesData: event.devicesData,
      availableDevices: event.availableDevices,
      key: UniqueKey(),
    );
    emit(newState);
  }

  Future<void> _onCheckUSBDevicesConnectionStateEvent(
    CheckUSBDevicesConnectionStateEvent event,
    Emitter<DevicesState> emit,
  ) async {
    final List<DeviceData> availableDevices = await usbDeviceInfoGetter.getDeviceProductInfo();
    final Iterable<DeviceData> nonUsbDevices = state.availableDevices.where(
      (DeviceData element) => element is! UsbDeviceData,
    );
    availableDevices.addAll(nonUsbDevices);
    final List<DeviceData> devicesData = <DeviceData>[];
    for (DeviceData deviceData in state.devicesData) {
      await _processDeviceConnectivity(
        isDeviceConnected: () => availableDevices.any((DeviceData device) => device.isSameDevice(deviceData)),
        devicesData: devicesData,
        deviceData: deviceData,
      );
    }

    final UpdateDevices updateDevices = UpdateDevices(
      devicesData: devicesData,
      availableDevices: availableDevices,
    );
    add(updateDevices);
    if (availableDevices.length != state.availableDevices.length) {
      add(LoadAvailableDevicesEvent());
    }
  }

  Future<void> _onDeviceConnectionChange(
    DeviceConnectionChange event,
    Emitter<DevicesState> emit,
  ) async {
    await _processDeviceConnectivity(
      isDeviceConnected: () => event.connected,
      deviceData: event.deviceData,
      devicesData: state.devicesData,
    );
  }

  Future<void> _processDeviceConnectivity({
    required bool Function() isDeviceConnected,
    required List<DeviceData> devicesData,
    required DeviceData deviceData,
  }) async {
    final bool iConnected = isDeviceConnected();
    final DeviceData updatedDevice = deviceData.copyWith(connected: iConnected);
    devicesData.removeWhere((DeviceData device) => device.isSameDevice(deviceData));
    devicesData.add(updatedDevice);
    final DeviceInterface? deviceInterface =
        state.deviceInstances.firstWhereOrNull((DeviceInterface device) => device.deviceData.isSameDevice(deviceData));
    if (iConnected && !deviceData.connected) {
      await _processConnectedDevice(
        deviceData: deviceData,
        updatedDevice: updatedDevice,
        deviceInterface: deviceInterface,
      );
    }

    deviceInterface?.deviceData = updatedDevice;
    final UpdateDevices updateDevices = UpdateDevices(
      devicesData: devicesData,
      availableDevices: state.availableDevices,
    );
    add(updateDevices);
  }

  Future<void> _processConnectedDevice({
    required DeviceData deviceData,
    required DeviceData updatedDevice,
    DeviceInterface? deviceInterface,
  }) async {
    if (deviceInterface is UsbDeviceInterface) {
      await _reInitDevHandle(
        deviceInterface: deviceInterface,
        deviceData: updatedDevice,
      );
    }
  }

  Future<void> _reInitDevHandle({required UsbDeviceInterface deviceInterface, required DeviceData deviceData}) async {
    if (!deviceData.connected) {
      await deviceInterface.dispose();
      usbDeviceDataSender.closeDevice(deviceInterface);
      await usbDeviceDataSender.openDevice(deviceInterface);
      await deviceInterface.isOpen.stream.firstWhere((bool value) => value).timeout(Duration(seconds: 10));
      await deviceInterface.init();
    }
  }

  Future<void> _onUpdateDevicePropertiesEvent(UpdateDeviceProperties event, Emitter<DevicesState> emit) async {
    final DeviceInterface deviceInterface = event.deviceInterface;
    final DeviceData deviceData = deviceInterface.deviceData;
    final List<DeviceInterface> deviceInstances = state.deviceInstances;
    final List<DeviceData> devicesData = state.devicesData;
    final DeviceData updatedDeviceData = deviceData.copyWith(
      offset: event.offset ?? deviceData.offset,
      scale: event.scale ?? deviceData.scale,
      rotation: event.rotation ?? deviceData.rotation,
    );
    deviceInterface.deviceData = updatedDeviceData;

    if (deviceInterface case final SubDeviceInterface subDevice) {
      final LightningControllerInterface parent = subDevice.parent as LightningControllerInterface;
      final int index = parent.subDevices.indexOf(subDevice);
      parent.deviceData.subDevicesData[index] = updatedDeviceData as SubDeviceData;
    } else {
      final int index = deviceInstances.indexOf(deviceInterface);
      devicesData[index] = updatedDeviceData;
    }

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
    final Map<String, Object?> payload = event.deviceInterface.getPayload();
    await usbDeviceDataSender.sendData(<Map<String, Object?>>[payload]);
  }

  Future<void> _onSelectDeviceEvent(
    final SelectDevicesEvent event,
    final Emitter<DevicesState> emit,
  ) async {
    final DevicesState newState = state.copyWith(
      selectedDevice: event.device,
      key: UniqueKey(),
    );
    emit(newState);
    final ValueNotifier<Object?> rightPanelSelectionNotifier =
        GetIt.instance.get(instanceName: 'rightPanelSelectionNotifier');
    rightPanelSelectionNotifier.value = event.device;
  }

  Future<void> _onUpdateDeviceDataEvent(
    UpdateDeviceDataEvent event,
    Emitter<DevicesState> emit,
  ) async {
    final DeviceData updatedDeviceData = event.deviceData;
    final List<DeviceInterface> updatedInstances = state.deviceInstances.map((DeviceInterface instance) {
      if (instance.deviceData.isSameDevice(updatedDeviceData)) {
        instance.deviceData = updatedDeviceData;
      } else if (instance is LightningControllerInterface) {
        for (SubDeviceInterface subDevice in instance.subDevices) {
          if (subDevice.deviceData.isSameDevice(updatedDeviceData)) {
            subDevice.deviceData = updatedDeviceData;
            final int index = instance.subDevices.indexOf(subDevice);
            instance.deviceData.subDevicesData[index] = updatedDeviceData as SubDeviceData;
          }
        }
      }

      return instance;
    }).toList();
    final DevicesState newState = state.copyWith(
      devicesData: updatedInstances.map((DeviceInterface device) => device.deviceData).toList(),
      deviceInstances: updatedInstances,
      key: UniqueKey(),
    );
    emit(newState);
  }
}
