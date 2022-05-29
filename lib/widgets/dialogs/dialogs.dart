import 'package:flutter/material.dart';

import '../../devices/device.dart';
import '../device_tile/device_tile.dart';

class Dialogs {
  static DialogRoute<void> showAddDeviceDialog(
    BuildContext context,
    Function() onTap,
    List<Device> availableDevices,
  ) {
    List<Widget> deviceTiles = availableDevices
        .map((Device device) => DeviceTile(
              device: device,
              onTap: onTap,
            ))
        .toList();
    final Widget child = Column(children: deviceTiles);
    return _showDialog(context, child, 'Choose device');
  }

  static DialogRoute<void> _showDialog(
    BuildContext context,
    Widget child,
    String title,
  ) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Color.fromARGB(255, 50, 50, 50),
        child: Container(
          width: 500,
          height: 400,
          child: Column(
            children: <Widget>[
              _title(title),
              child,
            ],
          ),
        ),
      ),
    );
  }

  static Widget _title(
    String title,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 20, top: 10),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
