import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/widgets/left_panel/generic_list_container/generic_list_container.dart';

class DevicesListContainer extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    context.select<DevicesBloc, int>((final DevicesBloc devicesBloc) => devicesBloc.state.devicesData.length);
    context.select<DevicesBloc, List<DeviceData>>((final DevicesBloc devicesBloc) => devicesBloc.state.connectedDevices);
    context.select<DevicesBloc, int>((final DevicesBloc devicesBloc) => devicesBloc.state.availableDevices.length);

    final DevicesBloc devicesBloc = context.read();
    final DevicesState state = devicesBloc.state;
    final List<DeviceData> availableDevices = state.availableDevices;

    return GenericListContainer<DeviceData>(
      getIcon: _getIcon,
      getName: _getName,
      isDisabled: _isDisabled,
      values: state.devicesData,
      onReorder: (final int oldIndex, final int newIndex) => _onReorder(devicesBloc, oldIndex, newIndex),
      dialogLabel: 'Choose devices',
      onAdd: (final DeviceData device) => _addDevice(devicesBloc, device),
      onRemove: (final DeviceData device) => _removeDevice(devicesBloc, device),
      availableValues: availableDevices,
    );
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

  void _addDevice(final DevicesBloc devicesBloc, final DeviceData deviceData) {
    final AddDeviceEvent addDeviceEvent = AddDeviceEvent(deviceData: deviceData);
    devicesBloc.add(addDeviceEvent);
  }

  void _removeDevice(final DevicesBloc devicesBloc, final DeviceData deviceData) {
    final RemoveDeviceEvent removeDeviceEvent = RemoveDeviceEvent(deviceData: deviceData);
    devicesBloc.add(removeDeviceEvent);
  }
}
