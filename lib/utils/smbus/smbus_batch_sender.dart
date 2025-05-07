import 'package:rgb_app/devices/smbus/models/smbus_transaction_data.dart';
import 'package:rgb_app/utils/frame_throttler.dart';
import 'package:rgb_app/utils/smbus/smbus.dart';

class SMBusBatchSender with FrameThrottler {
  final Smbus smbus;

  SMBusBatchSender(this.smbus);

  void send(List<SMBusTransactionData> data) => runThrottled(() => smbus.writeTransactionBatch(transactions: data));
}
