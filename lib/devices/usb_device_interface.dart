import 'package:flutter/cupertino.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/utils/usb_device_data_sender/usb_device_data_sender.dart';

abstract class UsbDeviceInterface extends DeviceInterface {
  late String guid;
  final UsbDeviceDataSender usbDeviceDataSender;

  int get interface;

  int get configuration;

  @protected
  int get dataLength;

  @protected
  List<List<int>> get initializePackets;

  UsbDeviceInterface({required this.usbDeviceDataSender, required super.deviceData});

  @override
  UsbDeviceData get deviceData => super.deviceData as UsbDeviceData;

  @protected
  Map<String, Object> getDataToSend();

  @protected
  List<List<int>> getPackets();

  Map<String, Object?> getPayload() => <String, Object?>{
        'packets': getPackets(),
        'guid': guid,
        ...getDataToSend(),
      };

  Map<String, Object?> getCustomPayload(List<List<int>> packets) => <String, Object?>{
        'packets': packets,
        'guid': guid,
        ...getDataToSend(),
      };

  @override
  Future<void> init() async {
    await super.init();
    if (isOpen.valueOrNull ?? false) {
      await _initializeDevice();
    }
  }

  @protected
  Future<void> sendPacket(List<int> bytes, int length, {Duration delay = const Duration(milliseconds: 100)}) async {
    final List<int> packet = List<int>.filled(length, 0x00);
    for (int i = 0; i < bytes.length && i < length; i++) {
      packet[i] = bytes[i];
    }
    await usbDeviceDataSender.sendData(
      <Map<String, Object?>>[
        getCustomPayload(<List<int>>[packet]),
      ],
      throttled: false,
    );
    await Future<void>.delayed(delay);
  }

  Future<void> _initializeDevice() async {
    for (final List<int> packet in initializePackets) {
      await sendPacket(packet, dataLength);
    }
  }
}
