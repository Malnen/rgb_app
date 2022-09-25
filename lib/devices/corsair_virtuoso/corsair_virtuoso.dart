import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rgb_app/packet_managers/corsair_virtuoso_packet_manager.dart';

import '../device_interface.dart';

class CorsairVirtuoso extends DeviceInterface {
  Color color = Color.fromARGB(1, 0, 0, 0);

  late Uint8List dataPkt1;
  late Uint8List lPkt1;
  late Uint8List dataPkt2;
  late Uint8List rPkt1;
  late CorsairVirtuosoPacketManager packetManager;

  CorsairVirtuoso({
    required super.device,
  });

  @override
  void init() {
    libusb.libusb_init(nullptr);
    devHandle = DeviceInterface.initDeviceHandler(
      device: device,
      configuration: 1,
      interface: 0,
    );
    packetManager = CorsairVirtuosoPacketManager(this);
    packetManager.fill();
    sendData();
  }

  @override
  void blink() {
    // TODO: implement blink
  }

  @override
  void sendData() {
    packetManager.sendData();
  }

  @override
  void test() {
    // TODO: implement test
  }

  @override
  void update() {
    // TODO: implement update
  }
}
