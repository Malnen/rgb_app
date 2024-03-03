import 'package:rgb_app/devices/enums/transfer_type.dart';

mixin InterruptTransferDevice {
  int get endpoint;

  int get length;

  int get timeout;

  TransferType get transferType => TransferType.interrupt;

  Map<String, Object> getDataToSend() {
    return <String, Object>{
      'endpoint': endpoint,
      'length': length,
      'timeout': timeout,
      'transferType': transferType.name,
    };
  }
}
