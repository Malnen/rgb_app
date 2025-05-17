import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/enums/numeric_property_type.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/udp_network_device_details.dart';
import 'package:rgb_app/utils/frame_throttler.dart';

class UdpNetworkDeviceInterface extends DeviceInterface with FrameThrottler {
  late List<Color> _colors;
  late NumericProperty ledCount;
  RawDatagramSocket? _socket;
  bool _ready = true;
  Timer? _timeout;

  UdpNetworkDeviceInterface({
    required super.deviceData,
  }) {
    ledCount = NumericProperty(
      initialValue: 1,
      name: 'Led count',
      idn: 'ledCount',
      min: 1,
      max: 1000,
      propertyType: NumericPropertyType.textField,
    );
    _colors = List<Color>.generate(ledCountValue, (_) => Colors.black);
  }

  List<Color> get colors => _colors;

  int get ledCountValue => ledCount.value.toInt();

  @override
  UdpNetworkDeviceData get deviceData => super.deviceData as UdpNetworkDeviceData;

  @override
  List<Property<Object>> get properties => <Property<Object>>[
        ledCount,
      ];

  @override
  Future<void> init() async {
    await super.init();
    _socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    _socket!.readEventsEnabled = true;
    _socket!.listen(_onDatagram);
    ledCount.addValueChangeListener((_) => _colors = List<Color>.generate(ledCountValue, (_) => Colors.black));
  }

  @override
  void update() {
    try {
      for (int i = 0; i < ledCountValue; i++) {
        _colors[i] = effectsColorsCubit.colors[offsetY][offsetX + i];
      }
    } catch (_) {
      print('$offsetX, $offsetY out of range: ${deviceData.name}');
    }

    super.update();
  }

  void sendData() => runThrottled(() async {
        if (_ready && _socket != null) {
          _ready = false;
          _startTimeout();
          final Uint8List buffer = Uint8List(ledCountValue * 3);
          for (int i = 0; i < ledCountValue; i++) {
            final Color color = _colors[ledCountValue - 1 - i];
            buffer[i * 3 + 0] = color.redInt;
            buffer[i * 3 + 1] = color.greenInt;
            buffer[i * 3 + 2] = color.blueInt;
          }

          final UdpNetworkDeviceDetails udpNetworkDeviceDetails = deviceData.udpNetworkDeviceDetails;
          _socket!.send(buffer, udpNetworkDeviceDetails.ip, udpNetworkDeviceDetails.port);
        }
      });

  void _onDatagram(RawSocketEvent event) {
    if (event == RawSocketEvent.read) {
      final Datagram? datagram = _socket?.receive();
      if (datagram != null && datagram.data.length == 1 && datagram.data[0] == 0x01) {
        _timeout?.cancel();
        _ready = true;
      }
    }
  }

  void _startTimeout() {
    _timeout?.cancel();
    _timeout = Timer(const Duration(milliseconds: 100), () => _ready = true);
  }

  @override
  Size getSize() => Size(ledCount.value, 1);

  @override
  void blink() {}

  @override
  void test() {}

  @override
  Future<void> dispose() async {
    _timeout?.cancel();
    _socket?.close();
    await super.dispose();
  }
}
