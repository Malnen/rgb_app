import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_event.dart';
import 'package:rgb_app/blocs/key_bloc/key_state.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/widgets/left_panel/generic_list_container/generic_list_container.dart';
import 'package:collection/collection.dart';

class DevicesListContainer extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    context.select<DevicesBloc, int>((final DevicesBloc devicesBloc) => devicesBloc.state.devicesData.length);
    context
        .select<DevicesBloc, List<DeviceData>>((final DevicesBloc devicesBloc) => devicesBloc.state.connectedDevices);
    context.select<DevicesBloc, int>((final DevicesBloc devicesBloc) => devicesBloc.state.availableDevices.length);

    final DevicesBloc devicesBloc = context.read();
    final KeyBloc keyBloc = GetIt.instance.get();
    final DevicesState state = devicesBloc.state;
    final List<DeviceData> availableDevices = state.availableDevices;
    _updateKeyBloc(keyBloc: keyBloc, devicesBloc: devicesBloc);

    return GenericListContainer<DeviceData>(
      getIcon: _getIcon,
      getName: _getName,
      isDisabled: _isDisabled,
      values: state.devicesData,
      onReorder: (final int oldIndex, final int newIndex) => _onReorder(devicesBloc, oldIndex, newIndex),
      dialogLabel: 'Choose devices',
      onAdd: (final DeviceData deviceData) => _addDevice(
        devicesBloc: devicesBloc,
        deviceData: deviceData,
      ),
      onRemove: (final DeviceData deviceData) => _removeDevice(
        devicesBloc: devicesBloc,
        deviceData: deviceData,
      ),
      availableValues: availableDevices,
    );
  }

  void _updateKeyBloc({
    required final KeyBloc keyBloc,
    required final DevicesBloc devicesBloc,
  }) {
    final KeyState keyState = keyBloc.state;
    final KeyboardInterface? keyboardInterface = keyState.keyboardInterface;
    final bool hasKeyboard = keyboardInterface != null;
    final bool keyboardStillExists = devicesBloc.deviceInstances.contains(keyboardInterface);
    if (!hasKeyboard || !keyboardStillExists) {
      _setFirstKeyboard(
        keyBloc: keyBloc,
        devicesBloc: devicesBloc,
      );
    }
  }

  void _setFirstKeyboard({
    required final KeyBloc keyBloc,
    required final DevicesBloc devicesBloc,
  }) {
    final List<DeviceInterface> deviceInstances = devicesBloc.deviceInstances;
    final KeyboardInterface? firstKeyboard = deviceInstances
        .firstWhereOrNull((final DeviceInterface element) => element is KeyboardInterface) as KeyboardInterface?;
    final SetKeyboardDeviceEvent event = SetKeyboardDeviceEvent(keyboardInterface: firstKeyboard);
    keyBloc.add(event);
  }

  IconData _getIcon(final DeviceData value) {
    final DeviceProductVendor deviceProductVendor = value.deviceProductVendor;
    return deviceProductVendor.icon;
  }

  String _getName(final DeviceData value) {
    final DeviceProductVendor deviceProductVendor = value.deviceProductVendor;
    return deviceProductVendor.name;
  }

  bool _isDisabled(final DeviceData value) => !value.connected;

  void _onReorder(final DevicesBloc devicesBloc, final int oldIndex, final int newIndex) {
    final ReorderDevicesEvent reorderDevices = ReorderDevicesEvent(oldIndex: oldIndex, newIndex: newIndex);
    devicesBloc.add(reorderDevices);
  }

  void _addDevice({
    required final DevicesBloc devicesBloc,
    required final DeviceData deviceData,
  }) {
    final AddDeviceEvent addDeviceEvent = AddDeviceEvent(deviceData: deviceData);
    devicesBloc.add(addDeviceEvent);
  }

  void _removeDevice({
    required final DevicesBloc devicesBloc,
    required final DeviceData deviceData,
  }) {
    final RemoveDeviceEvent removeDeviceEvent = RemoveDeviceEvent(deviceData: deviceData);
    devicesBloc.add(removeDeviceEvent);
  }
}
