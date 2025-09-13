import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_event.dart';
import 'package:rgb_app/blocs/key_bloc/key_state.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/widgets/left_panel/add_generic_button/simple_button.dart';
import 'package:rgb_app/widgets/left_panel/generic_list_container/generic_list_container.dart';

class DevicesListContainer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final DevicesBloc devicesBloc = GetIt.instance.get();
    final KeyBloc keyBloc = GetIt.instance.get();
    final DevicesState state = useBlocBuilder(devicesBloc);
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
      onTap: (DeviceData deviceData) => _onSelect(devicesBloc, deviceData),
      onRemove: (DeviceData deviceData) => _removeDevice(
        devicesBloc: devicesBloc,
        deviceData: deviceData,
      ),
      availableValues: availableDevices,
      topHeaderChildren: <Widget>[
        SimpleButton(
          icon: Icons.refresh,
          onTap: () => devicesBloc.add(RefreshDevicesEvent()),
        ),
      ],
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
    final KeyboardInterface? firstKeyboard =
        deviceInstances.firstWhereOrNull((DeviceInterface element) => element is KeyboardInterface) as KeyboardInterface?;
    final SetKeyboardDeviceEvent event = SetKeyboardDeviceEvent(
      keyboardInterface: firstKeyboard,
      key: UniqueKey(),
    );
    keyBloc.add(event);
  }

  IconData _getIcon(DeviceData value) => value.icon!;

  String _getName(DeviceData value) => value.name;

  bool _isDisabled(DeviceData value) => !value.connected;

  void _onReorder(DevicesBloc devicesBloc, int oldIndex, int newIndex) {
    final ReorderDevicesEvent reorderDevices = ReorderDevicesEvent(oldIndex: oldIndex, newIndex: newIndex);
    devicesBloc.add(reorderDevices);
  }

  void _addDevice({
    required DevicesBloc devicesBloc,
    required DeviceData deviceData,
  }) {
    final AddDeviceEvent addDeviceEvent = AddDeviceEvent(deviceData);
    devicesBloc.add(addDeviceEvent);
  }

  void _removeDevice({
    required DevicesBloc devicesBloc,
    required DeviceData deviceData,
  }) {
    final RemoveDeviceEvent removeDeviceEvent = RemoveDeviceEvent(deviceData);
    devicesBloc.add(removeDeviceEvent);
  }

  void _onSelect(DevicesBloc bloc, DeviceData deviceData) {
    final DevicesState state = bloc.state;
    final List<DeviceInterface> devices = state.deviceInstances;
    final DeviceInterface? device = devices.firstWhereOrNull((DeviceInterface element) => element.deviceData.isSameDevice(deviceData));
    if (device != null) {
      final DevicesEvent event = DevicesEvent.selectDevice(device: device);
      bloc.add(event);
    }
  }
}
