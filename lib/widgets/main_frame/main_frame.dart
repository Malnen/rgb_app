import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/widgets/left_panel/left_panel.dart';
import 'package:rgb_app/widgets/right_panel/right_panel.dart';

import '../../blocs/devices_bloc/devices_bloc.dart';
import '../../devices/device.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  List<Device> deviceProductInfo = [];

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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RGB App',
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
        body: _body(),
      ),
    );
  }

  Column _body() {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              LeftPanel(),
              RightPanel(),
            ],
          ),
        ),
      ],
    );
  }
}
