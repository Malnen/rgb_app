import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

import '../../blocs/devices_bloc/devices_state.dart';
import '../../devices/device.dart';
import '../dialogs/dialogs.dart';

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
