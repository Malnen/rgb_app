import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/smbus_device_details.freezed.dart';
part '../generated/models/smbus_device_details.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class SMBusDeviceDetails with _$SMBusDeviceDetails {
  @override
  final String name;
  @override
  final int address;

  bool get isUnknown => address < 1;

  SMBusDeviceDetails({
    required this.name,
    required this.address,
  });

  factory SMBusDeviceDetails.unknownSMBusDeviceDetails() => SMBusDeviceDetails(
        name: '',
        address: 0,
      );

  factory SMBusDeviceDetails.fromJson(Map<String, Object?> json) => _$SMBusDeviceDetailsFromJson(json);

  Map<String, Object?> toJson() => _$SMBusDeviceDetailsToJson(this);
}
