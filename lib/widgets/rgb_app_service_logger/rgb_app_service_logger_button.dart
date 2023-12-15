import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RgbAppServiceLoggerButton extends HookWidget {
  final ValueNotifier<bool> opened;

  RgbAppServiceLoggerButton(this.opened);

  @override
  Widget build(BuildContext context) {
    final AnimationController controller = useAnimationController(duration: Duration(milliseconds: 100));
    return SizedBox.square(
      dimension: 24,
      child: ElevatedButton(
        onPressed: () {
          opened.value = !opened.value;
          opened.value ? controller.forward() : controller.reverse();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 35, 35, 35),
          alignment: Alignment.center,
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(4)),
          ),
        ),
        child: RotationTransition(
          turns: Tween<double>(begin: 0, end: .5).animate(controller),
          child: Icon(
            Icons.keyboard_arrow_up,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
