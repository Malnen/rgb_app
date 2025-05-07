import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/devices/smbus/models/smbus_transaction_entry.dart';

part '../../../generated/devices/smbus/models/smbus_transaction_data.freezed.dart';
part '../../../generated/devices/smbus/models/smbus_transaction_data.g.dart';

@freezed
@JsonSerializable()
class SMBusTransactionData with _$SMBusTransactionData {
  @override
  final int address;
  @override
  final List<SMBusTransactionEntry> transactions;

  SMBusTransactionData(this.address, this.transactions);

  factory SMBusTransactionData.fromJson(Map<String, Object?> json) => _$SMBusTransactionDataFromJson(json);

  Map<String, Object?> toJson() => _$SMBusTransactionDataToJson(this);
}
