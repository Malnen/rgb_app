import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/bluetooth_device_details.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:win_ble/win_ble.dart';
import 'package:win_ble/win_file.dart';

BluetoothService get bluetoothService => GetIt.instance.get();

class BluetoothService {
  final Set<String> _discoveredDevices;
  final Set<String> _pendingDevices;
  final Set<String> _pendingReconnectDevices;

  BluetoothService()
      : _discoveredDevices = <String>{},
        _pendingDevices = <String>{},
        _pendingReconnectDevices = <String>{};

  late BleState availabilityState;

  bool get hasBluetooth => availabilityState == BleState.On;

  Future<void> initialize() async {
    await WinBle.initialize(serverPath: await WinServer.path());
    WinBle.bleState.listen((BleState state) {
      availabilityState = state;
      WinBle.stopScanning();
      if (hasBluetooth) {
        WinBle.startScanning();
      }
    });
    final DevicesBloc devicesBloc = GetIt.instance.get();
    WinBle.scanStream.listen((BleDevice result) async {
      final bool isAlreadyDiscovered = _discoveredDevices.any((String device) => device == result.address);
      if (!isAlreadyDiscovered && result.name.isNotEmpty) {
        _discoveredDevices.add(result.address);
        final BluetoothDeviceDetails bluetoothDeviceDetails = BluetoothDeviceDetails.fromBleDevice(result);
        if (!bluetoothDeviceDetails.isUnknown) {
          final BluetoothDeviceData deviceData = BluetoothDeviceData(bluetoothDeviceDetails: bluetoothDeviceDetails);
          if (!devicesBloc.state.availableDevices.contains(deviceData)) {
            final AddAvailableDeviceEvent addDeviceEvent = AddAvailableDeviceEvent(deviceData);
            devicesBloc.add(addDeviceEvent);
          }
        }
      }

      final bool wasAdded = devicesBloc.state.devicesData
          .whereType<BluetoothDeviceData>()
          .where((BluetoothDeviceData device) => !device.connected)
          .any((BluetoothDeviceData device) => device.bluetoothDeviceDetails.deviceId == result.address);
      if (wasAdded && !_pendingReconnectDevices.contains(result.address)) {
        final DeviceData? deviceData = devicesBloc.state.devicesData
            .whereType<BluetoothDeviceData>()
            .where(
              (BluetoothDeviceData element) => element.bluetoothDeviceDetails.deviceId == result.address,
            )
            .firstOrNull;
        final DeviceInterface? deviceInterface = devicesBloc.state.deviceInstances.firstWhereOrNull(
          (DeviceInterface element) => deviceData != null && element.deviceData.isSameDevice(deviceData),
        );
        if (deviceData != null && deviceInterface != null) {
          _pendingReconnectDevices.add(result.address);
          final ReConnectBluetoothDeviceEvent event = ReConnectBluetoothDeviceEvent(deviceData as BluetoothDeviceData);
          devicesBloc.add(event);
          await deviceInterface.isOpen.take(1).first;
          _pendingReconnectDevices.remove(result.address);
        }
      }
    });
    WinBle.connectionStream.listen(
      (Map<String, Object?> event) => _onConnectionChange(devicesBloc, event),
    );
  }

  Future<void> connect(BluetoothDeviceData deviceData, DeviceInterface deviceInterface) async {
    final String deviceId = deviceData.bluetoothDeviceDetails.deviceId;
    if (!_pendingDevices.contains(deviceId)) {
      _pendingDevices.add(deviceId);
      await WinBle.disconnect(deviceId);
      await WinBle.connect(deviceId).then(
        (_) async {
          _pendingDevices.remove(deviceId);
          deviceInterface.isOpen.sink.add(true);
          final DeviceConnectionChange deviceConnectionChange = DeviceConnectionChange(
            deviceData: deviceData,
            connected: true,
          );
          final DevicesBloc devicesBloc = GetIt.instance.get();
          devicesBloc.add(deviceConnectionChange);
        },
      ).onError(
        (_, __) {
          final DeviceConnectionChange deviceConnectionChange = DeviceConnectionChange(
            deviceData: deviceData,
            connected: false,
          );
          final DevicesBloc devicesBloc = GetIt.instance.get();
          devicesBloc.add(deviceConnectionChange);
          _pendingDevices.remove(deviceId);
          deviceInterface.isOpen.sink.add(false);
        },
      );
    }
  }

  void _onConnectionChange(DevicesBloc devicesBloc, Map<String, Object?> event) {
    final String address = event['device'] as String? ?? '';
    final bool connected = event['connected'] as bool? ?? false;
    _pendingReconnectDevices.add(address);
    final DeviceData? deviceData = devicesBloc.state.devicesData
        .whereType<BluetoothDeviceData>()
        .where(
          (BluetoothDeviceData element) => element.bluetoothDeviceDetails.deviceId == address,
        )
        .firstOrNull;
    if (deviceData != null && deviceData.connected != connected) {
      final DeviceConnectionChange event = DeviceConnectionChange(
        deviceData: deviceData,
        connected: connected,
      );
      devicesBloc.add(event);
    }
    _pendingReconnectDevices.remove(address);
  }
}
