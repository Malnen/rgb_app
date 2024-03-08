import 'package:flutter/material.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/widgets/main_frame/main_scaffold.dart';
import 'package:window_manager/window_manager.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({super.key});

  @override
  State<StatefulWidget> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> with WindowListener {
  List<DeviceData> deviceProductInfo = <DeviceData>[];

  @override
  void initState() {
    windowManager.addListener(this);
    windowManager.setPreventClose(true);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RGB App',
      theme: ThemeData(
        useMaterial3: false,
        canvasColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 25, 25, 25),
        ),
        colorScheme: ColorScheme.dark(
          background: Color.fromARGB(255, 30, 30, 30),
        ),
      ),
      home: MainScaffold(),
    );
  }

  @override
  void onWindowFocus() {
    // setState(() {});
  }

  @override
  void onWindowClose() => windowManager.hide();
}
