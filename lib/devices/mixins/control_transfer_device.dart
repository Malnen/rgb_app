import 'package:rgb_app/devices/enums/transfer_type.dart';

mixin ControlTransferDevice {
  int get requestType;

  int get request;

  int get value;

  int get index;

  int get dataLength;

  int get timeout;

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
