import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/json_converters/property_converter.dart';
import 'package:rgb_app/json_converters/unique_key_converter.dart';
import 'package:rgb_app/json_converters/vector_3_converter.dart';
import 'package:rgb_app/models/device_product_vendor.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/models/smbus_device_details.dart';
import 'package:rgb_app/models/sub_device_details.dart';
import 'package:rgb_app/models/udp_network_device_details.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'package:vector_math/vector_math.dart';

part '../generated/models/device_data.freezed.dart';
part '../generated/models/device_data.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class DeviceData with _$DeviceData {
  @override
  @Vector3Converter()
  final vmath.Vector3 offset;
  @override
  @Vector3Converter()
  final vmath.Vector3 scale;
  @override
  @Vector3Converter()
  final vmath.Vector3 rotation;
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
    required this.offset,
    required this.scale,
    required this.rotation,
    this.connected = false,
    this.properties = const <Property<Object>>[],
  });

  factory DeviceData.fromJson(Map<String, Object?> json) {
    if (LightningControllerDeviceData.isAssignable(json)) {
      return LightningControllerDeviceData.fromJson(json);
    } else if (UsbDeviceData.isAssignable(json)) {
      return UsbDeviceData.fromJson(json);
    } else if (SMBusDeviceData.isAssignable(json)) {
      return SMBusDeviceData.fromJson(json);
    } else if (UdpNetworkDeviceData.isAssignable(json)) {
      return UdpNetworkDeviceData.fromJson(json);
    } else if (SubDeviceData.isAssignable(json)) {
      return SubDeviceData.fromJson(json);
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
  @Vector3Converter()
  final vmath.Vector3 offset;
  @override
  @Vector3Converter()
  final vmath.Vector3 scale;
  @override
  @Vector3Converter()
  final vmath.Vector3 rotation;
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

  @override
  final DeviceProductVendor deviceProductVendor;

  UsbDeviceData({
    required this.deviceProductVendor,
    required this.key,
    vmath.Vector3? offset,
    vmath.Vector3? scale,
    vmath.Vector3? rotation,
    this.connected = false,
    this.properties = const <Property<Object>>[],
  })  : offset = offset ?? Vector3.zero(),
        scale = scale ?? Vector3(1, 1, 1),
        rotation = rotation ?? Vector3(0, 0, 0),
        super(
          key: key,
          offset: offset ?? Vector3.zero(),
          scale: scale ?? Vector3(1, 1, 1),
          rotation: rotation ?? Vector3.zero(),
          properties: properties,
          connected: connected,
        );

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
  @Vector3Converter()
  final vmath.Vector3 offset;
  @override
  @Vector3Converter()
  final vmath.Vector3 scale;
  @override
  @Vector3Converter()
  final vmath.Vector3 rotation;
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

  @override
  final SMBusDeviceDetails smBusDeviceDetails;

  SMBusDeviceData({
    required this.smBusDeviceDetails,
    required this.key,
    vmath.Vector3? offset,
    vmath.Vector3? scale,
    vmath.Vector3? rotation,
    this.connected = false,
    this.properties = const <Property<Object>>[],
  })  : offset = offset ?? Vector3.zero(),
        scale = scale ?? Vector3(1, 1, 1),
        rotation = rotation ?? Vector3(0, 0, 0),
        super(
          key: key,
          offset: offset ?? Vector3.zero(),
          scale: scale ?? Vector3(1, 1, 1),
          rotation: rotation ?? Vector3.zero(),
          properties: properties,
          connected: connected,
        );

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
  @Vector3Converter()
  final vmath.Vector3 offset;
  @override
  @Vector3Converter()
  final vmath.Vector3 scale;
  @override
  @Vector3Converter()
  final vmath.Vector3 rotation;
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

  @override
  final UdpNetworkDeviceDetails udpNetworkDeviceDetails;

  UdpNetworkDeviceData({
    required this.udpNetworkDeviceDetails,
    required this.key,
    vmath.Vector3? offset,
    vmath.Vector3? scale,
    vmath.Vector3? rotation,
    this.connected = false,
    this.properties = const <Property<Object>>[],
  })  : offset = offset ?? Vector3.zero(),
        scale = scale ?? Vector3(1, 1, 1),
        rotation = rotation ?? Vector3(0, 0, 0),
        super(
          key: key,
          offset: offset ?? Vector3.zero(),
          scale: scale ?? Vector3(1, 1, 1),
          rotation: rotation ?? Vector3.zero(),
          properties: properties,
          connected: connected,
        );

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

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class SubDeviceData extends DeviceData with _$SubDeviceData {
  @override
  @Vector3Converter()
  final vmath.Vector3 offset;
  @override
  @Vector3Converter()
  final vmath.Vector3 scale;
  @override
  @Vector3Converter()
  final vmath.Vector3 rotation;
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

  @override
  final SubDeviceDetails subDeviceDetails;

  SubDeviceData({
    required this.subDeviceDetails,
    required this.key,
    vmath.Vector3? offset,
    vmath.Vector3? scale,
    vmath.Vector3? rotation,
    this.connected = false,
    this.properties = const <Property<Object>>[],
  })  : offset = offset ?? Vector3.zero(),
        scale = scale ?? Vector3(1, 1, 1),
        rotation = rotation ?? Vector3(0, 0, 0),
        super(
          key: key,
          offset: offset ?? Vector3.zero(),
          scale: scale ?? Vector3(1, 1, 1),
          rotation: rotation ?? Vector3.zero(),
          properties: properties,
          connected: connected,
        );

  factory SubDeviceData.fromJson(Map<String, Object?> json) => _$SubDeviceDataFromJson(json);

  factory SubDeviceData.empty() => SubDeviceData(
        subDeviceDetails: SubDeviceDetails.unknownSubDeviceDetails(),
        key: UniqueKey(),
      );

  static bool isAssignable(Map<String, Object?> json) => json.containsKey('subDeviceDetails');

  @override
  Map<String, Object?> toJson() => _$SubDeviceDataToJson(this);

  @override
  bool isSameDevice(DeviceData deviceData) {
    if (deviceData is SubDeviceData) {
      return deviceData.subDeviceDetails.uniqueId == subDeviceDetails.uniqueId;
    }

    return false;
  }

  @override
  String get name => subDeviceDetails.name;

  @override
  IconData? get icon => Icons.square;

  @override
  bool get isKnownDevice => !subDeviceDetails.isUnknown;
}

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class LightningControllerDeviceData extends UsbDeviceData with _$LightningControllerDeviceData {
  @override
  @Vector3Converter()
  final vmath.Vector3 offset;
  @override
  @Vector3Converter()
  final vmath.Vector3 scale;
  @override
  @Vector3Converter()
  final vmath.Vector3 rotation;
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
  @override
  final DeviceProductVendor deviceProductVendor;

  @override
  final List<SubDeviceData> subDevicesData;

  LightningControllerDeviceData({
    required this.deviceProductVendor,
    required this.key,
    vmath.Vector3? offset,
    vmath.Vector3? scale,
    vmath.Vector3? rotation,
    this.connected = false,
    this.subDevicesData = const <SubDeviceData>[],
    this.properties = const <Property<Object>>[],
  })  : offset = offset ?? Vector3.zero(),
        scale = scale ?? Vector3(1, 1, 1),
        rotation = rotation ?? Vector3(0, 0, 0),
        super(
          deviceProductVendor: deviceProductVendor,
          key: key,
          offset: offset ?? Vector3.zero(),
          scale: scale ?? Vector3(1, 1, 1),
          rotation: rotation ?? Vector3.zero(),
          properties: properties,
          connected: connected,
        );

  factory LightningControllerDeviceData.empty() => LightningControllerDeviceData(
        deviceProductVendor: DeviceProductVendor.unknownProductVendor(),
        key: UniqueKey(),
      );

  factory LightningControllerDeviceData.fromJson(Map<String, Object?> json) =>
      _$LightningControllerDeviceDataFromJson(json);

  static bool isAssignable(Map<String, Object?> json) => json.containsKey('subDevicesData');

  @override
  Map<String, Object?> toJson() => _$LightningControllerDeviceDataToJson(this);
}
