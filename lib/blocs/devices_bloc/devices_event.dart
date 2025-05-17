import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/usb_device_interface.dart';
import 'package:rgb_app/models/device_data.dart';

part '../../generated/blocs/devices_bloc/devices_event.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
abstract class DevicesEvent with _$DevicesEvent {
  const factory DevicesEvent.addDevice(DeviceData deviceData) = AddDeviceEvent;

  const factory DevicesEvent.removeDevice(DeviceData deviceData) = RemoveDeviceEvent;

  const factory DevicesEvent.restoreDevices() = RestoreDevicesEvent;

  const factory DevicesEvent.loadAvailableDevices() = LoadAvailableDevicesEvent;

  const factory DevicesEvent.addAvailableDevice(DeviceData deviceData) = AddAvailableDeviceEvent;

  const factory DevicesEvent.updateDevices({
    required List<DeviceData> devicesData,
    required List<DeviceData> availableDevices,
  }) = UpdateDevices;

  const factory DevicesEvent.reorderDevices({
    required int oldIndex,
    required int newIndex,
  }) = ReorderDevicesEvent;

  const factory DevicesEvent.updateDeviceOffset({
    required int offsetX,
    required int offsetY,
    required DeviceInterface deviceInterface,
  }) = UpdateDeviceOffsetEvent;

  const factory DevicesEvent.checkDevicesConnectionState() = CheckUSBDevicesConnectionStateEvent;

  const factory DevicesEvent.deviceConnectionChange({
    required DeviceData deviceData,
    required bool connected,
  }) = DeviceConnectionChange;

  const factory DevicesEvent.sendDataManually(UsbDeviceInterface deviceInterface) = SendDataManuallyEvent;

  const factory DevicesEvent.selectDevice({
    required DeviceInterface device,
  }) = SelectDevicesEvent;

  const factory DevicesEvent.updateDeviceDataEvent({required DeviceData deviceData}) = UpdateDeviceDataEvent;
}
