import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_event.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';
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
  late KeyBloc keyBloc;

  @override
  void initState() {
    super.initState();
    devicesBloc = GetIt.instance.get();
    keyBloc = KeyBloc();
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
        appBar: AppBar(
          title: const Text('¯\\_(ツ)_/¯'),
        ),
        body: _buildMultiBlocProvider(),
      ),
    );
  }

  MultiBlocProvider _buildMultiBlocProvider() {
    return MultiBlocProvider(
      child: BlocListener<DevicesBloc, DevicesState>(
        child: _body(),
        listener: devicesBlocListener,
        bloc: devicesBloc,
      ),
      providers: [
        BlocProvider<KeyBloc>.value(
          value: keyBloc,
        ),
      ],
    );
  }

  void devicesBlocListener(BuildContext context, DevicesState state) {
    final DeviceInterface? firstKeyboard =
        state.deviceInstances.firstWhereOrNull((DeviceInterface element) => element is KeyboardInterface);
    SetOffsetEvent setOffsetEvent = SetOffsetEvent(
      offsetX: firstKeyboard?.offsetX ?? 0,
      offsetY: firstKeyboard?.offsetY ?? 0,
    );
    keyBloc.add(setOffsetEvent);
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
