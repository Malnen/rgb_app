import 'package:rgb_app/devices/enums/transfer_type.dart';
import 'package:rgb_app/utils/tick_provider.dart';

mixin ControlTransferDevice {
  int get requestType;

  int get request;

  int get value;

  int get index;

  int get dataLength;

  int get timeout => TickProvider.frameTime;

  TransferType get transferType => TransferType.control;

  Map<String, Object> getDataToSend() {
    return <String, Object>{
      'requestType': requestType,
      'request': request,
      'value': value,
      'index': index,
      'dataLength': dataLength,
      'timeout': timeout,
      'transferType': transferType.name,
    };
  }
}
