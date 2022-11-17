import 'package:flutter/material.dart';

class DialogManager {
  static DialogRoute<void> showDialog({
    required BuildContext context,
    required Widget child,
    required String title,
  }) {
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
