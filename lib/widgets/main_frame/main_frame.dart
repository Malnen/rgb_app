import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/enums/device_product_vendor.dart';

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
    deviceProductInfo = QuickUsb().getDeviceProductInfo();
    _devicesBloc = DevicesBloc();
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
        appBar: AppBar(
          title: const Text('¯\\_(ツ)_/¯r'),
        ),
        body: BlocListener(
            child: _child(),
            bloc: _devicesBloc,
            listener: (BuildContext context, DevicesState state) {
              /*Timer.periodic(
                const Duration(milliseconds: 100),
                (Timer t) {
                  final SteelSeriesRival100 steelSeriesRival100 =
                      ((state as DevicesInitialState)
                              .deviceInstances
                              .firstWhere((DeviceInterface device) =>
                                  device.device.deviceProductVendor ==
                                  DeviceProductVendor.steelSeriesRival100)
                          as SteelSeriesRival100);
                  steelSeriesRival100.color = Color.fromARGB(
                    1,
                    Random().nextInt(255),
                    Random().nextInt(255),
                    Random().nextInt(255),
                  );
                  steelSeriesRival100.sendData();
                },
              );*/
            }),
      ),
    );
  }

  Column _child() {
    return Column(
      children: [
        InkWell(
          child: const Text('Add Corsair K70'),
          onTap: () {
            _devicesBloc.add(
              AddDeviceEvent(
                device: deviceProductInfo.firstWhere((Device device) =>
                    device.deviceProductVendor ==
                    DeviceProductVendor.corsairK70),
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
    );
  }
}
