import 'package:flutter/material.dart';
import 'package:rgb_app/widgets/add_device_button/add_device_button.dart';

import '../dialogs/dialogs.dart';

class DevicesListContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DevicesListContainer();
}

class _DevicesListContainer extends State<DevicesListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: child(),
      color: Color.fromARGB(255, 26, 26, 26),
    );
  }

  Column child() {
    return Column(
      children: <Widget>[
        top(),
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
}
