import 'dart:ffi';
import 'dart:typed_data';

import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k70_packet_filler.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k70_tester.dart';
import 'package:rgb_app/devices/device_interface.dart';

import '../device.dart';
import 'corsair_k_70_packets.dart';

class CorsairK70 extends DeviceInterface {
  final KeyBloc? keyBloc;

  CorsairK70({
    required Device device,
    this.keyBloc,
  }) : super(device: device);

  late Uint8List dataPkt1;
  late Uint8List rPkt1;
  late Uint8List gPkt1;
  late Uint8List bPkt1;

  late Uint8List dataPkt2;
  late Uint8List rPkt2;
  late Uint8List gPkt2;
  late Uint8List bPkt2;

  late Uint8List dataPkt3;
  late Uint8List rPkt3;
  late Uint8List gPkt3;
  late Uint8List bPkt3;
  late CorsairK70PacketManager packetManager;

  @override
  void init() {
    libusb.libusb_init(nullptr);
    devHandle = libusb.libusb_open_device_with_vid_pid(
      nullptr,
      int.parse('0x${device.vendorId}'),
      int.parse('0x${device.productId}'),
    );

    libusb.libusb_claim_interface(devHandle, 1);
    libusb.libusb_set_configuration(devHandle, 1);
    packetManager = CorsairK70PacketManager(this);
    packetManager.fill();
    //test();
    blink();
  }

  @override
  void sendData() {
    packetManager.sendData();
  }

  @override
  void test() {
    CorsairK70Tester tester = CorsairK70Tester(
      corsairK70: this,
      keyBloc: keyBloc,
    );
    tester.test();
  }

  @override
  void blink() {
    CorsairK70Tester tester = CorsairK70Tester(
      corsairK70: this,
      keyBloc: keyBloc,
    );
    tester.blink();
  }

  CorsairK70Packets getPacket(int index) {
    switch (index) {
      case 0:
        return CorsairK70Packets(
          rPkt: rPkt1,
          gPkt: gPkt1,
          bPkt: bPkt1,
        );
      case 1:
        return CorsairK70Packets(
          rPkt: rPkt2,
          gPkt: gPkt2,
          bPkt: bPkt2,
        );
      case 2:
        return CorsairK70Packets(
          rPkt: rPkt3,
          gPkt: gPkt3,
          bPkt: bPkt3,
        );
    }

    return CorsairK70Packets.empty();
  }
}
