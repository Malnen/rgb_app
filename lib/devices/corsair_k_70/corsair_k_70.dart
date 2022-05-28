import 'dart:ffi';
import 'dart:typed_data';

import 'package:libusb/libusb64.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k70_packet_filler.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k70_tester.dart';
import 'package:rgb_app/devices/device_interface.dart';

import '../../utils/libusb_loader.dart';
import '../device.dart';

class CorsairK70 extends DeviceInterface {
  final KeyBloc? keyBloc;

  CorsairK70({
    required Device device,
    this.keyBloc,
  }) : super(device: device);

  Libusb get libusb => LibusbLoader.getInstance;

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
    test();
  }

  @override
  void sendData() {
    packetManager.sendData();
  }

  @override
  void dispose() {
    libusb.libusb_close(devHandle);
  }

  @override
  void test() {
    CorsairK70Tester tester = CorsairK70Tester(
      corsairK70: this,
      keyBloc: keyBloc,
    );
    tester.test();
  }
}
