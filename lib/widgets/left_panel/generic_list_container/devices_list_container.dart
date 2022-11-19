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
  Widget build(BuildContext context) {
    context.select<DevicesBloc, int>((DevicesBloc devicesBloc) => devicesBloc.state.devices.length);
    context.select<DevicesBloc, int>((DevicesBloc devicesBloc) => devicesBloc.state.availableDevices.length);

    final DevicesBloc devicesBloc = context.read();
    final DevicesState state = devicesBloc.state;
    final availableDevices = state.availableDevices.where(_isKnownDevice).toList();

    return GenericListContainer<Device>(
      getIcon: _getIcon,
      getName: _getName,
      values: state.devices,
      dialogLabel: 'Choose devices',
      onAdd: (Device device) => _addDevice(devicesBloc, device),
      onRemove: (Device device) => _removeDevice(devicesBloc, device),
      availableValues: availableDevices,
    );
  }

  bool _isKnownDevice(Device device) {
    final DeviceProductVendor deviceProductVendor = device.deviceProductVendor;
    return deviceProductVendor.productVendor != DeviceProductVendor.unknown;
  }

  IconData _getIcon(Device value) {
    final DeviceProductVendor deviceProductVendor = value.deviceProductVendor;
    return deviceProductVendor.icon;
  }

  String _getName(Device value) {
    final DeviceProductVendor deviceProductVendor = value.deviceProductVendor;
    return deviceProductVendor.name;
  }

  void _addDevice(DevicesBloc devicesBloc, Device device) {
    final AddDeviceEvent addDeviceEvent = AddDeviceEvent(device: device);
    devicesBloc.add(addDeviceEvent);
  }

  void _removeDevice(DevicesBloc devicesBloc, Device device) {
    final RemoveDeviceEvent removeDeviceEvent = RemoveDeviceEvent(device: device);
    devicesBloc.add(removeDeviceEvent);
  }
}
