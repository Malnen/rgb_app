import 'package:flutter/material.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

import '../../devices/device.dart';

class DeviceTile extends StatelessWidget {
  final Device device;
  final void Function(Device device) onTap;

  const DeviceTile({
    required this.device,
    required this.onTap,
  });

  DeviceProductVendor get _deviceProductVendor => device.deviceProductVendor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 40,
      margin: EdgeInsets.only(top: 6),
      child: _content(context),
    );
  }

  Widget _content(BuildContext context) {
    return Material(
      color: Color.fromARGB(255, 70, 70, 70),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () => _onTap(context),
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: <Widget>[
            _icon(),
            _name(),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    onTap(device);
  }

  Widget _icon() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      child: Icon(
        _deviceProductVendor.icon,
        color: Colors.white,
      ),
    );
  }

  Widget _name() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        _deviceProductVendor.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
