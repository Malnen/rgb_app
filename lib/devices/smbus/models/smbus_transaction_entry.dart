import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/devices/smbus/models/smbus_transaction_entry.freezed.dart';
part '../../../generated/devices/smbus/models/smbus_transaction_entry.g.dart';

@freezed
@JsonSerializable()
class SMBusTransactionEntry with _$SMBusTransactionEntry {
  @override
  final int command;
  @override
  final int value;

  SMBusTransactionEntry(this.command, this.value);

  factory SMBusTransactionEntry.fromJson(Map<String, Object?> json) => _$SMBusTransactionEntryFromJson(json);

  Map<String, Object?> toJson() => _$SMBusTransactionEntryToJson(this);
}
