import 'package:flutter/material.dart';

class DialogManager {
  static DialogRoute<T> showDialog<T>({
    required BuildContext context,
    required Widget child,
    required String title,
    double width = 500,
    double height = 400,
  }) {
    return DialogRoute<T>(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Color.fromARGB(255, 50, 50, 50),
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
