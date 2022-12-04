import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/packet_managers/corsair_virtuoso_packet_manager.dart';
import 'package:rgb_app/testers/corsair_virtuoso_tester.dart';

class CorsairVirtuoso extends DeviceInterface {
  Color color = Color.fromARGB(1, 0, 0, 0);

  late Uint8List dataPkt1;
  late Uint8List lPkt1;
  late Uint8List dataPkt2;
  late Uint8List rPkt1;
  late CorsairVirtuosoPacketManager packetManager;
  late CorsairVirtuosoTester tester;

  CorsairVirtuoso({
    required super.device,
  });

  @override
  void init() {
    super.init();
    tester = CorsairVirtuosoTester(corsairVirtuoso: this);
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
  // packetManager.sendData();
  }

  @override
  void test() {
    tester.test();
  }

  @override
  void update() {
    // TODO: implement update
  }

  @override
  void initDevHandle() {
    devHandle = DeviceInterface.initDeviceHandler(
      device: device,
      configuration: 1,
      interface: 3,
    );
  }
}
