import 'package:flutter/material.dart';

class LoadingBarrier extends StatelessWidget {
  LoadingBarrier();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withAlpha(102),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.orange,
            strokeWidth: 5,
          ),
        ),
      ),
    );
  }
}
