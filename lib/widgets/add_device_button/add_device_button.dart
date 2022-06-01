import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

import '../../blocs/devices_bloc/devices_state.dart';
import '../../devices/device.dart';
import '../dialogs/dialogs.dart';

class AddDeviceButton extends StatefulWidget {
  @override
  State<AddDeviceButton> createState() => _AddDeviceButtonState();
}

class _AddDeviceButtonState extends State<AddDeviceButton> {
  late DevicesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 16, 16, 16),
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      onTap: _onTap,
    );
  }

  void _onTap() {
    final DevicesState state = bloc.state;
    List<Device> availableDevices = state.availableDevices;
    availableDevices = availableDevices
        .where((Device device) =>
            device.deviceProductVendor.productVendor != DeviceProductVendor.unknown)
        .toList();
    Navigator.of(context).push(
      Dialogs.showAddDeviceDialog(
        context,
        _addDeviceEvent,
        availableDevices,
      ),
    );
  }

  void _addDeviceEvent(Device device) {
    AddDeviceEvent event = AddDeviceEvent(
      device: device,
      keyBloc: context.read(),
    );
    bloc.add(event);
    Navigator.of(context).pop();
  }
}
