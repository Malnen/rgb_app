import 'package:flutter/material.dart';
import 'package:rgb_app/devices/enums/transfer_type.dart';
import 'package:rgb_app/utils/tick_provider.dart';

mixin InterruptTransferDevice {
  @protected
  int get endpoint;

  @protected
  int get dataLength;

  @protected
  int get timeout => TickProvider.frameTime;

  @protected
  TransferType get transferType => TransferType.interrupt;

  @protected
  Map<String, Object> getDataToSend() {
    return <String, Object>{
      'endpoint': endpoint,
      'length': dataLength,
      'timeout': timeout,
      'transferType': transferType.name,
    };
  }
}
