import 'package:flutter/material.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

class DeviceTile extends StatelessWidget {
  final DeviceProductVendor device;
  final void Function() onTap;

  const DeviceTile({
    required this.device,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 40,
      margin: EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(255, 70, 70, 70),
      ),
      child: _name(),
    );
  }

  Widget _name() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        device.name,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
