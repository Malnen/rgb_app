import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/devices/device.dart';
import 'package:rgb_app/widgets/main_frame/main_scaffold.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({final Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  List<Device> deviceProductInfo = <Device>[];

  late DevicesBloc devicesBloc;

  @override
  void initState() {
    super.initState();
    devicesBloc = GetIt.instance.get();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'RGB App',
      theme: ThemeData(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        canvasColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 25, 25, 25),
        ),
      ),
      home: MainScaffold(),
    );
  }
}
