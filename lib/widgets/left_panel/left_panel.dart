import 'package:flutter/material.dart';
import 'package:rgb_app/widgets/devices_list_container/devices_list_container.dart';

class LeftPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      height: double.infinity,
      child: Container(
        decoration: _getBoxDecoration(),
        child: DevicesListContainer(),
      ),
    );
  }

  BoxDecoration _getBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 1,
          blurRadius: 3,
          offset: Offset(0, 3),
        ),
      ],
    );
  }
}
