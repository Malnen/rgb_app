import 'package:flutter/material.dart';
import 'package:rgb_app/widgets/devices_list_container/devices_list_container.dart';

class LeftPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: _getBoxDecoration(),
      child: ListView(
        controller: ScrollController(),
        children: [
          Column(
            children: <Widget>[
              DevicesListContainer(),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _getBoxDecoration() {
    return BoxDecoration(
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
