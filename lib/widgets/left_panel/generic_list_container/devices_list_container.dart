import 'package:collection/collection.dart';
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

class DevicesListContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.select<DevicesBloc, int>((DevicesBloc devicesBloc) => devicesBloc.state.devicesData.length);
    context.select<DevicesBloc, List<DeviceData>>((DevicesBloc devicesBloc) => devicesBloc.state.connectedDevices);
    context.select<DevicesBloc, int>((DevicesBloc devicesBloc) => devicesBloc.state.availableDevices.length);

    final DevicesBloc devicesBloc = GetIt.instance.get();
    final KeyBloc keyBloc = GetIt.instance.get();
    final DevicesState state = devicesBloc.state;
    final List<DeviceData> availableDevices = state.availableDevices;
    _updateKeyBloc(keyBloc: keyBloc, devicesBloc: devicesBloc);

    return GenericListContainer<DeviceData>(
      getIcon: _getIcon,
      getName: _getName,
      isDisabled: _isDisabled,
      values: state.devicesData,
      onReorder: (int oldIndex, int newIndex) => _onReorder(devicesBloc, oldIndex, newIndex),
      dialogLabel: 'Choose devices',
      onAdd: (DeviceData deviceData) => _addDevice(
        devicesBloc: devicesBloc,
        deviceData: deviceData,
      ),
      onTap: (_) {},
      onRemove: (DeviceData deviceData) => _removeDevice(
        devicesBloc: devicesBloc,
        deviceData: deviceData,
      ),
      availableValues: availableDevices,
    );
  }

  void _updateKeyBloc({
    required KeyBloc keyBloc,
    required DevicesBloc devicesBloc,
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
    required KeyBloc keyBloc,
    required DevicesBloc devicesBloc,
  }) {
    final List<DeviceInterface> deviceInstances = devicesBloc.deviceInstances;
    final KeyboardInterface? firstKeyboard = deviceInstances
        .firstWhereOrNull((DeviceInterface element) => element is KeyboardInterface) as KeyboardInterface?;
    final SetKeyboardDeviceEvent event = SetKeyboardDeviceEvent(keyboardInterface: firstKeyboard);
    keyBloc.add(event);
  }

  IconData _getIcon(DeviceData value) {
    final DeviceProductVendor deviceProductVendor = value.deviceProductVendor;
    return deviceProductVendor.icon;
  }

  String _getName(DeviceData value) {
    final DeviceProductVendor deviceProductVendor = value.deviceProductVendor;
    return deviceProductVendor.name;
  }

  bool _isDisabled(DeviceData value) => !value.connected;

  void _onReorder(DevicesBloc devicesBloc, int oldIndex, int newIndex) {
    final ReorderDevicesEvent reorderDevices = ReorderDevicesEvent(oldIndex: oldIndex, newIndex: newIndex);
    devicesBloc.add(reorderDevices);
  }

  void _addDevice({
    required DevicesBloc devicesBloc,
    required DeviceData deviceData,
  }) {
    final AddDeviceEvent addDeviceEvent = AddDeviceEvent(deviceData: deviceData);
    devicesBloc.add(addDeviceEvent);
  }

  void _removeDevice({
    required DevicesBloc devicesBloc,
    required DeviceData deviceData,
  }) {
    final RemoveDeviceEvent removeDeviceEvent = RemoveDeviceEvent(deviceData: deviceData);
    devicesBloc.add(removeDeviceEvent);
  }
}
