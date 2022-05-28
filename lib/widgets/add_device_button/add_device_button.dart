import 'package:flutter/material.dart';

import '../dialogs/dialogs.dart';

class AddDeviceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _addButton(context);
  }

  InkWell _addButton(BuildContext context) {
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
      onTap: () {
        Navigator.of(context).restorablePush(_dialogBuilder);
      },
    );
  }

  static Route<Object?> _dialogBuilder(
    BuildContext context,
    Object? arguments,
  ) {
    return Dialogs.showAddDeviceDialog(
      context,
      () {},
    );
  }
}
