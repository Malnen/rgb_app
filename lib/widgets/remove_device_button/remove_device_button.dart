import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';

import '../../devices/device.dart';

class RemoveDeviceButton extends StatefulWidget {
  final Device device;

  const RemoveDeviceButton({required this.device});

  @override
  State<RemoveDeviceButton> createState() => _RemoveDeviceButtonState();
}

class _RemoveDeviceButtonState extends State<RemoveDeviceButton> {
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
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onTap: _onTap,
    );
  }

  void _onTap() {
    RemoveDeviceEvent event = RemoveDeviceEvent(
      device: widget.device,
    );
    bloc.add(event);
  }

}
