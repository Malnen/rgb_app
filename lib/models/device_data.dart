import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/json_converters/property_converter.dart';
import 'package:rgb_app/json_converters/unique_key_converter.dart';
import 'package:rgb_app/models/device_product_vendor.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/smbus_device_details.dart';
import 'package:rgb_app/models/udp_network_device_details.dart';

part '../generated/models/device_data.freezed.dart';
part '../generated/models/device_data.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class DeviceData with _$DeviceData {
  @override
  final int offsetX;
  @override
  final int offsetY;
  @override
  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  final bool connected;
  @override
  @PropertyConverter()
  final List<Property<Object>> properties;
  @override
  @UniqueKeyConverter()
  final UniqueKey key;

  DeviceData({
    required this.key,
    this.offsetX = 0,
    this.offsetY = 0,
    this.connected = false,
    this.properties = const <Property<Object>>[],
  });

  factory DeviceData.fromJson(Map<String, Object?> json) {
    if (UsbDeviceData.isAssignable(json)) {
      return UsbDeviceData.fromJson(json);
    } else if (SMBusDeviceData.isAssignable(json)) {
      return SMBusDeviceData.fromJson(json);
    } else if (UdpNetworkDeviceData.isAssignable(json)) {
      return UdpNetworkDeviceData.fromJson(json);
    }

    throw UnsupportedError('Unsupported device data');
  }

  Map<String, Object?> toJson() => _$DeviceDataToJson(this);

  bool isSameDevice(DeviceData deviceData) => throw UnimplementedError();

  String get name => throw UnimplementedError();

  IconData? get icon => throw UnimplementedError();

  bool get isKnownDevice => throw UnimplementedError();
}

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class UsbDeviceData extends DeviceData with _$UsbDeviceData {
  @override
  final DeviceProductVendor deviceProductVendor;

  UsbDeviceData({
    required this.deviceProductVendor,
    required super.key,
    super.offsetX,
    super.offsetY,
    super.connected,
    super.properties,
  });

  factory UsbDeviceData.empty() => UsbDeviceData(
        deviceProductVendor: DeviceProductVendor.unknownProductVendor(),
        key: UniqueKey(),
      );

  factory UsbDeviceData.fromJson(Map<String, Object?> json) => _$UsbDeviceDataFromJson(json);

  static bool isAssignable(Map<String, Object?> json) => json.containsKey('deviceProductVendor');

  @override
  Map<String, Object?> toJson() => _$UsbDeviceDataToJson(this);

  @override
  bool isSameDevice(DeviceData deviceData) {
    if (deviceData is UsbDeviceData) {
      return deviceProductVendor == deviceData.deviceProductVendor;
    }

    return false;
  }

  @override
  String get name => deviceProductVendor.name;

  @override
  IconData? get icon => deviceProductVendor.icon;

  @override
  bool get isKnownDevice => !deviceProductVendor.isUnknown;
}

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class SMBusDeviceData extends DeviceData with _$SMBusDeviceData {
  @override
  final SMBusDeviceDetails smBusDeviceDetails;

  SMBusDeviceData({
    required this.smBusDeviceDetails,
    required super.key,
    super.offsetX,
    super.offsetY,
    super.connected,
    super.properties,
  });

  factory SMBusDeviceData.fromJson(Map<String, Object?> json) => _$SMBusDeviceDataFromJson(json);

  factory SMBusDeviceData.empty() => SMBusDeviceData(
        smBusDeviceDetails: SMBusDeviceDetails.unknownSMBusDeviceDetails(),
        key: UniqueKey(),
      );

  static bool isAssignable(Map<String, Object?> json) => json.containsKey('smBusDeviceDetails');

  @override
  Map<String, Object?> toJson() => _$SMBusDeviceDataToJson(this);

  @override
  bool isSameDevice(DeviceData deviceData) {
    if (deviceData is SMBusDeviceData) {
      return deviceData.smBusDeviceDetails.address == smBusDeviceDetails.address;
    }

    return false;
  }

  @override
  String get name => smBusDeviceDetails.name;

  @override
  IconData? get icon => Icons.gas_meter_rounded;

  @override
  bool get isKnownDevice => !smBusDeviceDetails.isUnknown;
}

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class UdpNetworkDeviceData extends DeviceData with _$UdpNetworkDeviceData {
  @override
  final UdpNetworkDeviceDetails udpNetworkDeviceDetails;

  UdpNetworkDeviceData({
    required this.udpNetworkDeviceDetails,
    required super.key,
    super.offsetX,
    super.offsetY,
    super.connected,
    super.properties,
  });

  factory UdpNetworkDeviceData.fromJson(Map<String, Object?> json) => _$UdpNetworkDeviceDataFromJson(json);

  factory UdpNetworkDeviceData.empty() => UdpNetworkDeviceData(
        udpNetworkDeviceDetails: UdpNetworkDeviceDetails.unknownUdpNetworkDeviceDetails(),
        key: UniqueKey(),
      );

  static bool isAssignable(Map<String, Object?> json) => json.containsKey('udpNetworkDeviceDetails');

  @override
  Map<String, Object?> toJson() => _$UdpNetworkDeviceDataToJson(this);

  @override
  bool isSameDevice(DeviceData deviceData) {
    if (deviceData is UdpNetworkDeviceData) {
      return deviceData.udpNetworkDeviceDetails.id == udpNetworkDeviceDetails.id;
    }

    return false;
  }

  @override
  String get name => udpNetworkDeviceDetails.name;

  @override
  IconData? get icon => Icons.wifi;

  @override
  bool get isKnownDevice => !udpNetworkDeviceDetails.isUnknown;
}
