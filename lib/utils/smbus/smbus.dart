import 'dart:async';

import 'package:rgb_app/devices/smbus/models/smbus_transaction_data.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service_listener.dart';
import 'package:rgb_app/utils/smbus/enums/smbus_command.dart';
import 'package:rgb_app/utils/smbus/enums/smbus_response_type.dart';
import 'package:rxdart/rxdart.dart';

class Smbus with RgbAppServiceListener<SMBusCommand, SMBusResponseType> {
  late BehaviorSubject<List<DeviceData>> deviceData;

  @override
  String get channelName => 'smbus';

  @override
  Iterable<SMBusResponseType> get responseTypes => SMBusResponseType.values;

  @override
  void Function(SMBusResponseType, Map<String, Object>) get processResponse => (_, __) {};

  @override
  Future<void> init() async {
    deviceData = BehaviorSubject<List<DeviceData>>();
    await super.init();
  }

  @override
  void dispose() {
    deviceData.close();
    super.dispose();
  }

  Future<int> readByte({required int address, required int command}) async {
    final Map<String, Object> response = await sendCommand(
      SMBusCommand.readByte,
      data: <String, Object>{
        'address': address,
        'command': command,
      },
    );
    return response['value'] as int;
  }

  Future<Map<String, Object>> writeByte({required int address, required int command, required int value}) async {
    return sendCommand(
      SMBusCommand.writeByte,
      data: <String, Object>{
        'address': address,
        'command': command,
        'value': value,
      },
    );
  }

  Future<int> readWord({required int address, required int command}) async {
    final Map<String, Object> response = await sendCommand(
      SMBusCommand.readWord,
      data: <String, Object>{
        'address': address,
        'command': command,
      },
    );
    return response['value'] as int;
  }

  Future<Map<String, Object>> writeQuick({required int address}) async {
    return sendCommand(
      SMBusCommand.writeQuick,
      data: <String, Object>{
        'address': address,
      },
    );
  }

  Future<Map<String, Object>> writeTransactionBatch({
    required List<SMBusTransactionData> transactions,
  }) async {
    return sendCommand(
      SMBusCommand.writeTransaction,
      data: <String, Object>{
        'transactions': transactions.map((SMBusTransactionData data) => data.toJson()).toList(),
      },
    );
  }
}
