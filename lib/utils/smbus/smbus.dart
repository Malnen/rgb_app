import 'dart:async';

import 'package:rgb_app/devices/smbus/models/smbus_transaction_data.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service_listener.dart';
import 'package:rgb_app/utils/smbus/enums/smbus_command.dart';
import 'package:rgb_app/utils/smbus/enums/smbus_response_type.dart';
import 'package:rxdart/rxdart.dart';

class Smbus with RgbAppServiceListener<SMBusCommand, SMBusResponseType> {
  late BehaviorSubject<List<DeviceData>> deviceData;
  late bool _isInitialized;

  @override
  String get channelName => 'smbus';

  @override
  Iterable<SMBusResponseType> get responseTypes => SMBusResponseType.values;

  @override
  void Function(SMBusResponseType, Map<String, Object>) get processResponse => _channelListener;

  @override
  Future<void> init() async {
    deviceData = BehaviorSubject<List<DeviceData>>();
    await super.init();
    await sendCommand(SMBusCommand.initialize);
  }

  @override
  void dispose() {
    deviceData.close();
    super.dispose();
  }

  Future<int> readByte({required int address, required int command}) => _guard(
        () async {
          final Map<String, Object> response = await sendCommand(
            SMBusCommand.readByte,
            data: <String, Object>{
              'address': address,
              'command': command,
            },
          );
          return response['value'] as int;
        },
        defaultValue: 0,
      );

  Future<Map<String, Object>> writeByte({required int address, required int command, required int value}) => _guard(
        () async => sendCommand(
          SMBusCommand.writeByte,
          data: <String, Object>{
            'address': address,
            'command': command,
            'value': value,
          },
        ),
        defaultValue: <String, Object>{},
      );

  Future<int> readWord({required int address, required int command}) => _guard(
        () async {
          final Map<String, Object> response = await sendCommand(
            SMBusCommand.readWord,
            data: <String, Object>{
              'address': address,
              'command': command,
            },
          );
          return response['value'] as int;
        },
        defaultValue: 0,
      );

  Future<Map<String, Object>> writeQuick({required int address}) => _guard(
        () async => sendCommand(
          SMBusCommand.writeQuick,
          data: <String, Object>{
            'address': address,
          },
        ),
        defaultValue: <String, Object>{},
      );

  Future<Map<String, Object>> writeTransactionBatch({
    required List<SMBusTransactionData> transactions,
  }) =>
      _guard(
        () async => sendCommand(
          SMBusCommand.writeTransaction,
          data: <String, Object>{
            'transactions': transactions.map((SMBusTransactionData data) => data.toJson()).toList(),
          },
        ),
        defaultValue: <String, Object>{},
      );

  void _channelListener(SMBusResponseType responseType, Map<String, Object> parsedData) {
    switch (responseType) {
      case SMBusResponseType.initialized:
        _isInitialized = true;
        break;
      case SMBusResponseType.notInitialized:
        _isInitialized = false;
        break;
      default:
        break;
    }
  }

  Future<T> _guard<T>(Future<T> Function() action, {required T defaultValue}) async {
    if (!_isInitialized) {
      return defaultValue!;
    }

    return action();
  }
}
