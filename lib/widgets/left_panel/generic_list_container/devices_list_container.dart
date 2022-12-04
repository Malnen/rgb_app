import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/devices/device.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:rgb_app/widgets/left_panel/generic_list_container/generic_list_container.dart';

class DevicesListContainer extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    context.select<DevicesBloc, int>((final DevicesBloc devicesBloc) => devicesBloc.state.devices.length);
    context.select<DevicesBloc, List<Device>>((final DevicesBloc devicesBloc) => devicesBloc.state.connectedDevices);
    context.select<DevicesBloc, int>((final DevicesBloc devicesBloc) => devicesBloc.state.availableDevices.length);

    final DevicesBloc devicesBloc = context.read();
    final DevicesState state = devicesBloc.state;
    final List<Device> availableDevices = state.availableDevices;

    return GenericListContainer<Device>(
      getIcon: _getIcon,
      getName: _getName,
      isDisabled: _isDisabled,
      values: state.devices,
      onReorder: (final int oldIndex, final int newIndex) => _onReorder(devicesBloc, oldIndex, newIndex),
      dialogLabel: 'Choose devices',
      onAdd: (final Device device) => _addDevice(devicesBloc, device),
      onRemove: (final Device device) => _removeDevice(devicesBloc, device),
      availableValues: availableDevices,
    );
  }

  IconData _getIcon(final Device value) {
    final DeviceProductVendor deviceProductVendor = value.deviceProductVendor;
    return deviceProductVendor.icon;
  }

  String _getName(final Device value) {
    final DeviceProductVendor deviceProductVendor = value.deviceProductVendor;
    return deviceProductVendor.name;
  }

  bool _isDisabled(final Device value) => !value.connected;

  void _onReorder(final DevicesBloc devicesBloc, final int oldIndex, final int newIndex) {
    final ReorderDevicesEvent reorderDevices = ReorderDevicesEvent(oldIndex: oldIndex, newIndex: newIndex);
    devicesBloc.add(reorderDevices);
  }

  void _addDevice(final DevicesBloc devicesBloc, final Device device) {
    final AddDeviceEvent addDeviceEvent = AddDeviceEvent(device: device);
    devicesBloc.add(addDeviceEvent);
  }

  void _removeDevice(final DevicesBloc devicesBloc, final Device device) {
    final RemoveDeviceEvent removeDeviceEvent = RemoveDeviceEvent(device: device);
    devicesBloc.add(removeDeviceEvent);
  }
}
