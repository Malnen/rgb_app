import 'package:flutter/cupertino.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/utils/device_data_sender.dart';

abstract class UsbDeviceInterface extends DeviceInterface {
  final DeviceDataSender deviceDataSender;
  late String guid;

  UsbDeviceInterface({required this.deviceDataSender, required super.deviceData});

  @override
  UsbDeviceData get deviceData => super.deviceData as UsbDeviceData;

  int get interface;

  int get configuration;

  @protected
  int get dataLength;

  @protected
  List<List<int>> get initializePackets;

  @protected
  bool get requiresWriteReadback => false;

  @protected
  int get readEndpoint => 0x02;

  @protected
  int get readLength => dataLength;

  @protected
  int get readTimeout => 1000;

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
      await initializeDevice();
    }
  }

  @protected
  Map<String, Object> getDataToSend();

  @protected
  List<List<int>> getPackets();

  @protected
  Future<void> sendPacket(List<int> bytes, int length, {Duration delay = const Duration(milliseconds: 100)}) async {
    final List<int> packet = List<int>.filled(length, 0x00);
    for (int i = 0; i < bytes.length && i < length; i++) {
      packet[i] = bytes[i];
    }
    await deviceDataSender.sendData(
      <Map<String, Object?>>[
        getCustomPayload(<List<int>>[packet]),
      ],
      throttled: false,
    );
    if (requiresWriteReadback) {
      await deviceDataSender.readData(
        guid: guid,
        endpoint: readEndpoint,
        length: readLength,
        timeout: readTimeout,
      );
    }
    await Future<void>.delayed(delay);
  }

  @protected
  Future<void> initializeDevice() async {
    for (final List<int> packet in initializePackets) {
      await sendPacket(packet, dataLength);
    }
  }
}
