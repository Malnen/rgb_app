import 'dart:async';

import 'package:rgb_app/devices/corsair_galleon_keyboard/corsair_galleon_keyboard.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/usb_device_interface.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/device_product_vendor.dart';
import 'package:rgb_app/utils/device_data_sender.dart';
import 'package:rgb_app/utils/frame_throttler.dart';
import 'package:rgb_app/utils/hid_device_data_sender/enums/hid_device_data_sender_command.dart';
import 'package:rgb_app/utils/hid_device_data_sender/enums/hid_device_data_sender_response_type.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service_listener.dart';

class HidDeviceDataSender
    with RgbAppServiceListener<HidDeviceDataSenderCommand, HidDeviceDataSenderResponseType>, FrameThrottler
    implements DeviceDataSender {
  final Map<String, DeviceInterface> pendingDevices;

  HidDeviceDataSender() : pendingDevices = <String, DeviceInterface>{};

  @override
  String get channelName => 'hidDeviceData';

  @override
  Iterable<HidDeviceDataSenderResponseType> get responseTypes => HidDeviceDataSenderResponseType.values;

  @override
  void Function(HidDeviceDataSenderResponseType, Map<String, Object>) get processResponse => _responseListener;

  @override
  Future<void> init() async {
    await initService();
  }

  @override
  Future<Map<String, Object>> openDevice(DeviceInterface deviceInterface) {
    final UsbDeviceInterface usbDeviceInterface = deviceInterface as UsbDeviceInterface;
    final UsbDeviceData deviceData = usbDeviceInterface.deviceData;
    final DeviceProductVendor deviceProductVendor = deviceData.deviceProductVendor;

    return _sendDeviceCommand(
      usbDeviceInterface,
      HidDeviceDataSenderCommand.openDevice,
      data: <String, Object>{
        'interface': usbDeviceInterface.interface,
        'configuration': usbDeviceInterface.configuration,
        'productId': deviceProductVendor.productId,
        'vendorId': deviceProductVendor.vendorId,
        'usage': 0x0001,
        'usagePage': 0xFF42,
      },
    );
  }

  @override
  Future<void> sendData(List<Map<String, Object?>> data, {bool throttled = true}) =>
      throttled ? runThrottled(() => _sendData(data)) : _sendData(data);

  @override
  Future<List<int>> readData({
    required String guid,
    required int endpoint,
    int length = 512,
    int timeout = 1000,
  }) async {
    final Map<String, Object> response = await sendCommand(
      HidDeviceDataSenderCommand.interruptRead,
      data: <String, Object>{
        'data': <String, Object>{
          'guid': guid,
          'endpoint': endpoint,
          'length': length,
          'timeout': timeout,
        },
      },
    );

    final Object? rawData = response['data'];
    if (rawData is List<dynamic>) {
      final List<int> data = rawData.map((Object? value) => value as int).toList();
      return data;
    }

    throw Exception('Invalid data format from HID interrupt read');
  }

  @override
  void closeDevice(DeviceInterface deviceInterface) {
    if (!deviceInterface.isOpen.isClosed) {
      deviceInterface.isOpen.add(false);
    }

    _sendDeviceCommand(
      deviceInterface,
      HidDeviceDataSenderCommand.closeDevice,
      data: <String, Object>{
        'guid': (deviceInterface as dynamic).guid as String,
      },
    );
  }

  Future<Map<String, Object>> _sendDeviceCommand(
    DeviceInterface deviceInterface,
    HidDeviceDataSenderCommand command, {
    Map<String, Object?>? data,
  }) {
    final UsbDeviceData deviceData = deviceInterface.deviceData as UsbDeviceData;
    final DeviceProductVendor deviceProductVendor = deviceData.deviceProductVendor;
    pendingDevices[deviceProductVendor.productVendor] = deviceInterface;
    return sendCommand(
      command,
      data: <String, Object?>{
        'data': data,
      },
    );
  }

  void _responseListener(HidDeviceDataSenderResponseType responseType, Map<String, Object> data) {
    switch (responseType) {
      case HidDeviceDataSenderResponseType.deviceOpened:
        _onDeviceOpened(data);
        break;
      case HidDeviceDataSenderResponseType.deviceOpenFailed:
        _onDeviceOpenFailed(data);
        break;
      case HidDeviceDataSenderResponseType.dataSent:
        break;
      case HidDeviceDataSenderResponseType.deviceClosed:
        break;
      case HidDeviceDataSenderResponseType.dataRead:
        break;
    }
  }

  void _onDeviceOpenFailed(Map<String, Object> data) {
    final DeviceProductVendor deviceProductVendor = DeviceProductVendor.getByProductVendor(data);
    final String productVendor = deviceProductVendor.productVendor;
    final DeviceInterface? deviceInterface = pendingDevices[productVendor];
    pendingDevices.remove(productVendor);
    deviceInterface?.isOpen.sink.add(false);
  }

  void _onDeviceOpened(Map<String, Object> data) {
    final DeviceProductVendor deviceProductVendor = DeviceProductVendor.getByProductVendor(data);
    final String productVendor = deviceProductVendor.productVendor;
    final DeviceInterface? deviceInterface = pendingDevices[productVendor];
    pendingDevices.remove(productVendor);
    if (deviceInterface != null) {
      (deviceInterface as dynamic).guid = data['guid'] as String;
      if (deviceInterface is CorsairGalleonKeyboard) {
        deviceInterface.configureHidReportLengths(
          writeLength: _readInt(data['outputReportLength']),
          readLength: _readInt(data['inputReportLength']),
        );
      }
      deviceInterface.isOpen.sink.add(true);
    }
  }

  int _readInt(Object? value) {
    if (value is int) {
      return value;
    } else if (value is num) {
      return value.toInt();
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  Future<void> _sendData(List<Map<String, Object?>> data) async {
    for (final Map<String, Object?> payload in data) {
      if (payload['readAfterPacketIndexes'] is List) {
        await _sendPacketByPacket(payload);
        continue;
      }

      await sendCommand(
        HidDeviceDataSenderCommand.sendData,
        data: <String, Object?>{
          'data': <Map<String, Object?>>[payload],
        },
      );
    }
  }

  Future<void> _sendPacketByPacket(Map<String, Object?> payload) async {
    final List<List<int>> packets = _extractPackets(payload);
    if (packets.isEmpty) {
      return;
    }

    final Map<String, Object?> basePayload = Map<String, Object?>.from(payload)..remove('packets');
    final String guid = basePayload['guid'] as String? ?? '';
    final int readEndpoint = basePayload['readEndpoint'] as int? ?? basePayload['endpoint'] as int? ?? 0x02;
    final int readLength = basePayload['readLength'] as int? ?? basePayload['length'] as int? ?? 64;
    final int readTimeout = basePayload['readTimeout'] as int? ?? basePayload['timeout'] as int? ?? 1000;
    final int readDelayMs = basePayload['readDelayMs'] as int? ?? 10;
    final Set<int> readAfterPacketIndexes = _extractIntSet(basePayload['readAfterPacketIndexes']);
    final Set<int> clearBeforePacketIndexes = _extractIntSet(basePayload['clearBeforePacketIndexes']);

    if (readAfterPacketIndexes.isEmpty && clearBeforePacketIndexes.isEmpty) {
      await sendCommand(
        HidDeviceDataSenderCommand.sendData,
        data: <String, Object?>{
          'data': <Map<String, Object?>>[
            <String, Object?>{
              ...basePayload,
              'packets': packets,
              'clearReadBuffer': false,
            },
          ],
        },
      );
      return;
    }

    for (int packetIndex = 0; packetIndex < packets.length; packetIndex++) {
      final List<int> packet = packets[packetIndex];
      final Map<String, Object?> packetPayload = <String, Object?>{
        ...basePayload,
        'packets': <List<int>>[packet],
        'clearReadBuffer': clearBeforePacketIndexes.contains(packetIndex),
      };

      await sendCommand(
        HidDeviceDataSenderCommand.sendData,
        data: <String, Object?>{
          'data': <Map<String, Object?>>[packetPayload],
        },
      );

      if (guid.isNotEmpty && readAfterPacketIndexes.contains(packetIndex)) {
        if (readDelayMs > 0) {
          await Future<void>.delayed(Duration(milliseconds: readDelayMs));
        }
        await readData(
          guid: guid,
          endpoint: readEndpoint,
          length: readLength,
          timeout: readTimeout,
        );
      }
    }
  }

  Set<int> _extractIntSet(Object? value) {
    if (value is! List) {
      return <int>{};
    }

    final Iterable<int> values = value.whereType<int>();
    final Set<int> result = values.toSet();

    return result;
  }

  List<List<int>> _extractPackets(Map<String, Object?> payload) {
    final Object? rawPackets = payload['packets'];
    if (rawPackets is! List) {
      return <List<int>>[];
    }

    final Iterable<List<Object?>> packetValues = rawPackets.whereType<List<Object?>>();
    final Iterable<List<int>> packets = packetValues.map((List<Object?> packet) {
      final Iterable<int> values = packet.cast<int>();
      final List<int> result = values.toList();

      return result;
    });
    final List<List<int>> result = packets.toList();

    return result;
  }
}
