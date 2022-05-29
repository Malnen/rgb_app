import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
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
        body: BlocProvider(
          create: (BuildContext context) => _devicesBloc,
          child: _child(),
        ),
      ),
    );
  }

  Widget _child() {
    return LeftPanel();
    /*return Column(
      children: [
        InkWell(
          child: const Text('Add Corsair K70'),
          onTap: () {
            _devicesBloc.add(
              AddDeviceEvent(
                device: deviceProductInfo.firstWhere((Device device) =>
                    device.deviceProductVendor ==
                    DeviceProductVendor.corsairK70),
                keyBloc: _keyBloc,
              ),
            );
          },
        ),
        InkWell(
          child: const Text('Add SteelSeries Rival 100'),
          onTap: () {
            _devicesBloc.add(
              AddDeviceEvent(
                device: deviceProductInfo.firstWhere((Device device) =>
                    device.deviceProductVendor ==
                    DeviceProductVendor.steelSeriesRival100),
              ),
            );
          },
        )
      ],
    );*/
  }
}
