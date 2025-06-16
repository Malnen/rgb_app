import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/devices/lightning_controller_interface.dart';
import 'package:rgb_app/devices/mixins/interrupt_transfer_device.dart';
import 'package:rgb_app/devices/sub_device_interface.dart';
import 'package:rgb_app/extensions/color_extension.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/sub_component.dart';
import 'package:rgb_app/models/sub_device_details.dart';
import 'package:rgb_app/utils/corsair/corsair_device_decoder.dart';
import 'package:vector_math/vector_math.dart';

class CorsairICueLinkHub extends LightningControllerInterface with InterruptTransferDevice {
  CorsairICueLinkHub({required super.deviceData, required super.usbDeviceDataSender});

  @override
  int get configuration => 1;

  @override
  int get interface => 0;

  @override
  int get endpoint => 0x04;

  @override
  int get dataLength => 512;

  @override
  int get timeout => 1000;
  bool ready = false;

  @override
  Vector3 getSize() => Vector3(1, 1, 1);

  @override
  List<List<int>> get initializePackets => <List<int>>[
        <int>[0x00, 0x01, 0x02, 0x03, 0x00, 0x00],
        <int>[0x00, 0x01, 0x09, 0x00, 0x00, 0x00],
        <int>[0x00, 0x01, 0x09, 0x01, 0x00, 0x00],
        <int>[0x00, 0x01, 0x09, 0x02, 0x00, 0x00],
        <int>[0x00, 0x01, 0x01, 0x03, 0x00, 0x02],
        <int>[0x00, 0x01, 0x02, 0x03, 0x00, 0x00],
        <int>[0x00, 0x01, 0x02, 0x11, 0x00, 0x00],
        <int>[0x00, 0x01, 0x02, 0x12, 0x00, 0x00],
        <int>[0x00, 0x01, 0x02, 0x13, 0x00, 0x00],
        <int>[0x00, 0x01, 0x09, 0x01, 0x00, 0x00],
        <int>[0x00, 0x01, 0x0d, 0x01, 0x21, 0x00],
        <int>[0x00, 0x01, 0x08, 0x01, 0x00, 0x00],
        <int>[0x00, 0x01, 0x05, 0x01, 0x01, 0x00],
        <int>[0x00, 0x00, 0x02, 0x36, 0x00, 0x00],
        <int>[0x00, 0x01, 0x02, 0x03, 0x00, 0x00],
        <int>[0x00, 0x01, 0x09, 0x00, 0x00, 0x00],
        <int>[0x00, 0x01, 0x09, 0x01, 0x00, 0x00],
        <int>[0x00, 0x01, 0x09, 0x02, 0x00, 0x00],
        <int>[0x00, 0x01, 0x01, 0x03, 0x00, 0x01],
        <int>[0x00, 0x01, 0x02, 0x03, 0x00, 0x00],
        <int>[0x00, 0x01, 0x02, 0x03, 0x00, 0x00],
        <int>[0x00, 0x01, 0x09, 0x00, 0x00, 0x00],
        <int>[0x00, 0x01, 0x09, 0x01, 0x00, 0x00],
        <int>[0x00, 0x01, 0x09, 0x02, 0x00, 0x00],
        <int>[0x00, 0x01, 0x01, 0x03, 0x00, 0x02],
        <int>[0x00, 0x01, 0x02, 0x03, 0x00, 0x00],
        <int>[0x00, 0x01, 0x09, 0x01, 0x00, 0x00],
        <int>[0x00, 0x01, 0x05, 0x01, 0x01, 0x00],
        <int>[0x00, 0x01, 0x0d, 0x01, 0x17, 0x00],
        <int>[0x00, 0x01, 0x08, 0x01, 0x00, 0x00],
        <int>[0x00, 0x01, 0x05, 0x01, 0x01, 0x00],
        <int>[0x00, 0x01, 0x09, 0x00, 0x00, 0x00],
        <int>[0x00, 0x01, 0x0d, 0x00, 0x36, 0x00],
        <int>[0x00, 0x01, 0x08, 0x00, 0x00, 0x00],
        <int>[0x00, 0x01, 0x05, 0x01, 0x00, 0x00],
        <int>[0x00, 0x01, 0x09, 0x00, 0x00, 0x00],
        <int>[0x00, 0x01, 0x0d, 0x00, 0x22, 0x00],
      ];

  @override
  void blink() {}

  @override
  void test() {}

  @override
  List<List<int>> getPackets() {
    final List<int> rgbData = <int>[];
    for (SubDeviceInterface subDevice in subDevices) {
      final SubComponent subComponent = subDevice.subComponent;
      final List<int> subComponentRgbData = <int>[];
      for (int i = 0; i < subComponent.ledPositions.length; i++) {
        final Vector3 ledPosition = subComponent.ledPositions[i];
        final Color color = getColorAt(
          x: ledPosition.x.toInt(),
          y: ledPosition.z.toInt(),
          scale: subDevice.scale,
          offset: subDevice.deviceData.offset,
          rotation: subDevice.deviceData.rotation,
          size: subDevice.getSize(),
        );
        subComponentRgbData.add(color.redInt);
        subComponentRgbData.add(color.greenInt);
        subComponentRgbData.add(color.blueInt);
      }

      rgbData.addAll(subComponentRgbData);
    }

    final List<List<int>> packets = <List<int>>[];
    final List<int> startHeader = <int>[
      0,
      1,
      6,
      0,
      ..._int32LittleEndian(rgbData.length),
      18,
      0,
    ];
    const List<int> middleHeader = <int>[0, 1, 7, 0];
    const List<int> finalPacket = <int>[0, 1, 9];
    int cursor = 0;
    final int firstPacketPayloadLength = dataLength - (startHeader.length);
    final List<int> firstPayload = rgbData.sublist(
      0,
      rgbData.length < firstPacketPayloadLength ? rgbData.length : firstPacketPayloadLength,
    );

    final List<int> firstPacket = <int>[
      ...startHeader,
      ...firstPayload,
    ];
    packets.add(firstPacket);

    cursor += firstPayload.length;
    while (cursor < rgbData.length) {
      final int remaining = rgbData.length - cursor;
      final int chunkSize =
          remaining < (dataLength - middleHeader.length) ? remaining : (dataLength - middleHeader.length);
      final List<int> chunk = rgbData.sublist(cursor, cursor + chunkSize);

      final List<int> packet = <int>[
        ...middleHeader,
        ...chunk,
      ];

      packets.add(packet);
      cursor += chunkSize;
    }

    packets.add(finalPacket);
    return _normalize(packets);
  }

  @override
  Future<void> init() async {
    await super.init();
    await _detectSubComponents();
  }

  List<int> _int32LittleEndian(int value) => <int>[
        value & 0xFF,
        (value >> 8) & 0xFF,
        (value >> 16) & 0xFF,
        (value >> 24) & 0xFF,
      ];

  List<List<int>> _normalize(List<List<int>> input) => input.map((List<int> packet) {
        if (packet.length >= dataLength) {
          return packet.sublist(0, 512);
        }

        return List<int>.from(packet)..addAll(List<int>.filled(dataLength - packet.length, 0x00));
      }).toList();

  Future<void> _detectSubComponents() async {
    final List<int> data = await usbDeviceDataSender.readData(
      endpoint: 0x84,
      guid: guid,
      length: 513,
      timeout: timeout,
    );

    final List<SubDeviceInterface> detectedSubDevices = CorsairDeviceDecoder.decodeChildren(data).map(
      (SubComponent subComponent) {
        final SubDeviceData? existingSubDeviceData = deviceData.subDevicesData.firstWhereOrNull(
          (SubDeviceData subDevice) => subDevice.subDeviceDetails.uniqueId == subComponent.uniqueIDString,
        );
        SubDeviceData subDeviceData = SubDeviceData(
          subDeviceDetails: SubDeviceDetails(
            deviceId: subComponent.deviceIDString,
            uniqueId: subComponent.uniqueIDString,
            name: subComponent.name,
          ),
          key: UniqueKey(),
        );
        if (existingSubDeviceData != null) {
          subDeviceData = subDeviceData.copyWith(
            offset: existingSubDeviceData.offset,
            scale: existingSubDeviceData.scale,
            rotation: existingSubDeviceData.rotation,
          );
        }

        return SubDeviceInterface(
          subComponent: subComponent,
          parent: this,
          deviceData: subDeviceData,
        );
      },
    ).toList();

    subDevices.addAll(detectedSubDevices);
    for (SubDeviceInterface subDevice in subDevices) {
      await subDevice.init();
    }

    deviceData = deviceData.copyWith(
      subDevicesData: subDevices
          .map(
            (SubDeviceInterface subDevice) => subDevice.deviceData,
          )
          .toList(),
    );
    devicesBloc.add(UpdateDeviceDataEvent(deviceData: deviceData));

    ready = true;
  }
}
