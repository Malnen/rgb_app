import 'package:flutter/material.dart';
import 'package:rgb_app/devices/enums/transfer_type.dart';
import 'package:rgb_app/utils/tick_provider.dart';

mixin ControlTransferDevice {
  @protected
  int get requestType;

  @protected
  int get request;

  @protected
  int get value;

  @protected
  int get index;

  @protected
  int get dataLength;

  @protected
  int get timeout => TickProvider.frameTime;

  @protected
  TransferType get transferType => TransferType.control;

  @protected
  Map<String, Object> getDataToSend() => <String, Object>{
        'requestType': requestType,
        'request': request,
        'value': value,
        'index': index,
        'dataLength': dataLength,
        'timeout': timeout,
        'transferType': transferType.name,
      };
}
