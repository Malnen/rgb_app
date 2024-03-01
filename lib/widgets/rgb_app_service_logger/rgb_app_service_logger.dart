import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service.dart';
import 'package:rgb_app/widgets/rgb_app_service_logger/rgb_app_service_logger_button.dart';

class RgbAppServiceLogger extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> opened = useState(false);
    final bool isOpen = opened.value;
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final RgbAppService rgbAppService = GetIt.instance.get();

    return SizedBox(
      width: screenWidth,
      height: screenSize.height,
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            width: isOpen ? screenWidth : 0,
            height: isOpen ? 200 : 0,
            bottom: 0,
            child: Container(
              color: Color.fromARGB(255, 35, 35, 35),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: <Widget>[
                    ValueListenableBuilder<String>(
                      valueListenable: rgbAppService.logs,
                      builder: (BuildContext context, String value, Widget? child) => Text(value),
                    ),
                  ],
                ),
              ),
            ),
            duration: Duration(milliseconds: 100),
          ),
          AnimatedPositioned(
            bottom: isOpen ? 176 : 0,
            right: 0,
            child: RgbAppServiceLoggerButton(opened),
            duration: Duration(milliseconds: 100),
          ),
        ],
      ),
    );
  }
}
