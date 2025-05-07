import 'package:rgb_app/devices/enums/transfer_type.dart';
import 'package:rgb_app/utils/tick_provider.dart';

mixin InterruptTransferDevice {
  int get endpoint;

  int get length;

  int get timeout => TickProvider.frameTime;

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
