import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/lightning_controller_interface.dart';
import 'package:rgb_app/devices/sub_device_interface.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/widgets/device_configurator/sub_components_list.dart';
import 'package:rgb_app/widgets/property_renderer/property_renderer.dart';

class DeviceConfigurator extends StatefulWidget {
  @override
  State<DeviceConfigurator> createState() => _DeviceConfiguratorState();
}

class _DeviceConfiguratorState extends State<DeviceConfigurator> {
  @override
  Widget build(BuildContext context) {
    final DeviceInterface? currentDevice = context.select<DevicesBloc, DeviceInterface?>((DevicesBloc bloc) => bloc.state.selectedDevice);
    return Wrap(
      spacing: 16,
      children: <Widget>[
        ..._getProperties(currentDevice),
        if (currentDevice is SubDeviceInterface)
          if (currentDevice.parent case final LightningControllerInterface lightningControllerInterface)
            SubComponentList(subComponents: lightningControllerInterface.subDevices),
        if (currentDevice is LightningControllerInterface) SubComponentList(subComponents: currentDevice.subDevices),
      ],
    );
  }

  List<Widget> _getProperties(DeviceInterface? currentDevice) {
    if (currentDevice != null) {
      return currentDevice.properties
          .where((Property<Object> property) => property.visible)
          .map(
            (Property<Object> property) => PropertyRenderer(
              property: property,
              updateRenderer: () => setState(() {}),
            ),
          )
          .toList();
    }

    return <Widget>[];
  }
}
