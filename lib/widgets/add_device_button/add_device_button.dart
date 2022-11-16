import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';
import 'package:rgb_app/widgets/device_tile/device_tile.dart';

import '../../blocs/devices_bloc/devices_state.dart';
import '../../devices/device.dart';
import '../dialogs/dialog_manager.dart';

class AddDeviceButton extends StatefulWidget {
  @override
  State<AddDeviceButton> createState() => _AddDeviceButtonState();
}

class _AddDeviceButtonState extends State<AddDeviceButton> {
  late DevicesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = GetIt.instance.get();
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
        .where((Device device) => device.deviceProductVendor.productVendor != DeviceProductVendor.unknown)
        .toList();

    Navigator.of(context).push(
      DialogManager.showDialog(
        context: context,
        title: 'Choose device',
        child: Column(
          children: [
            ...availableDevices.map(
              (Device device) => DeviceTile(
                device: device,
                onTap: _addDeviceEvent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addDeviceEvent(Device device) {
    AddDeviceEvent event = AddDeviceEvent(device: device);
    bloc.add(event);
    Navigator.of(context).pop();
  }
}
