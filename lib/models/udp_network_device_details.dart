import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';

part '../generated/models/udp_network_device_details.freezed.dart';
part '../generated/models/udp_network_device_details.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class UdpNetworkDeviceDetails with _$UdpNetworkDeviceDetails {
  @override
  final String id;
  @override
  final String name;
  @override
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  final String? address;
  @override
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  final int port;

  bool get isUnknown => id.isNotEmpty;

  InternetAddress get ip => InternetAddress(address ?? '');

  UdpNetworkDeviceDetails({
    required this.id,
    required this.name,
    this.address,
    this.port = 0,
  });

  factory UdpNetworkDeviceDetails.unknownUdpNetworkDeviceDetails() => UdpNetworkDeviceDetails(
        name: '',
        address: null,
        id: '',
        port: 0,
      );

  factory UdpNetworkDeviceDetails.fromJson(Map<String, Object?> json) => _$UdpNetworkDeviceDetailsFromJson(json);

  Map<String, Object?> toJson() => _$UdpNetworkDeviceDetailsToJson(this);
}
