import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/widgets/left_panel/left_panel.dart';

import '../../blocs/devices_bloc/devices_bloc.dart';
import '../../devices/device.dart';
import '../../quick_usb/quick_usb.dart';
import '../../utils/libusb_loader.dart';

class MainFrame extends StatefulWidget {
  const MainFrame({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainFrameState();
}

class _MainFrameState extends State<MainFrame> {
  List<Device> deviceProductInfo = [];

  late DevicesBloc _devicesBloc;
  late KeyBloc _keyBloc;

  @override
  void initState() {
    super.initState();
    LibusbLoader.initLibusb();
    final quickUsb = QuickUsb();
    deviceProductInfo = quickUsb.getDeviceProductInfo();
    _devicesBloc = DevicesBloc(availableDevices: deviceProductInfo);
    _keyBloc = KeyBloc();
    _devicesBloc.add(RestoreDevicesEvent());
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
            title: const Text('¯\\_(ツ)_/¯r'),
          ),
          body: MultiBlocProvider(
            child: LeftPanel(),
            providers: [
              BlocProvider<DevicesBloc>(
                create: (BuildContext context) => _devicesBloc,
              ),
              BlocProvider<KeyBloc>(
                create: (BuildContext context) => _keyBloc,
              ),
            ],
          )),
    );
  }
}
