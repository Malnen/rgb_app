import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/widgets/add_device_button/add_device_button.dart';
import 'package:rgb_app/widgets/device_tile/device_tile.dart';
import 'package:rgb_app/widgets/remove_device_button/remove_device_button.dart';

import '../../blocs/devices_bloc/devices_bloc.dart';
import '../../devices/device.dart';

class DevicesListContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DevicesListContainer();
}

class _DevicesListContainer extends State<DevicesListContainer> {
  List<Device> devices = [];

  late DevicesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = GetIt.instance.get();
    devices = bloc.state.devices;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: listener,
      bloc: bloc,
      child: Container(
        child: child(),
        color: Color.fromARGB(255, 26, 26, 26),
      ),
    );
  }

  void listener(BuildContext context, DevicesState state) {
    devices = state.devices;
    setState(() {});
  }

  Column child() {
    return Column(
      children: <Widget>[
        top(),
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          margin: EdgeInsets.only(left: 10, right: 20),
          child: Column(
            children: [
              ...getDevices(),
            ],
          ),
        )
      ],
    );
  }

  Widget top() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        left: 20,
        top: 5,
      ),
      child: Row(
        children: <Widget>[
          title(),
          SizedBox(width: 10),
          AddDeviceButton(),
        ],
      ),
    );
  }

  Widget title() {
    return const Text(
      'Devices',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
    );
  }

  List<Widget> getDevices() {
    return devices
        .map((Device device) => Row(
              children: [
                DeviceTile(
                  device: device,
                  onTap: (_) {},
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  margin: EdgeInsets.only(top: 6),
                  child: RemoveDeviceButton(device: device),
                )
              ],
            ))
        .toList();
  }
}
