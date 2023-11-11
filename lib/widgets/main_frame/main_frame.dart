import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/widgets/main_frame/main_scaffold.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({super.key});

  @override
  State<StatefulWidget> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  List<DeviceData> deviceProductInfo = <DeviceData>[];

  late DevicesBloc devicesBloc;

  @override
  void initState() {
    devicesBloc = GetIt.instance.get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RGB App',
      theme: ThemeData(
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
}
