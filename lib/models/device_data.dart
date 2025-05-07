import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/models/bluetooth_device_details.dart';
import 'package:rgb_app/models/device_product_vendor.dart';
import 'package:rgb_app/models/smbus_device_details.dart';

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

  DeviceData({
    this.offsetX = 0,
    this.offsetY = 0,
    this.connected = false,
  });

  factory DeviceData.fromJson(Map<String, Object?> json) {
    if (UsbDeviceData.isAssignable(json)) {
      return UsbDeviceData.fromJson(json);
    } else if (BluetoothDeviceData.isAssignable(json)) {
      return BluetoothDeviceData.fromJson(json);
    } else if (SMBusDeviceData.isAssignable(json)) {
      return SMBusDeviceData.fromJson(json);
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
    super.offsetX,
    super.offsetY,
    super.connected,
  });

  factory UsbDeviceData.empty() => UsbDeviceData(deviceProductVendor: DeviceProductVendor.unknownProductVendor());

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
class BluetoothDeviceData extends DeviceData with _$BluetoothDeviceData {
  @override
  final BluetoothDeviceDetails bluetoothDeviceDetails;

  BluetoothDeviceData({
    required this.bluetoothDeviceDetails,
    super.offsetX,
    super.offsetY,
    super.connected,
  });

  factory BluetoothDeviceData.fromJson(Map<String, Object?> json) => _$BluetoothDeviceDataFromJson(json);

  factory BluetoothDeviceData.empty() =>
      BluetoothDeviceData(bluetoothDeviceDetails: BluetoothDeviceDetails.unknownBluetoothDeviceDetails());

  static bool isAssignable(Map<String, Object?> json) => json.containsKey('bluetoothDeviceDetails');

  @override
  Map<String, Object?> toJson() => _$BluetoothDeviceDataToJson(this);

  @override
  bool isSameDevice(DeviceData deviceData) {
    if (deviceData is BluetoothDeviceData) {
      return deviceData.bluetoothDeviceDetails.deviceId == bluetoothDeviceDetails.deviceId;
    }

    return false;
  }

  @override
  String get name => bluetoothDeviceDetails.name;

  @override
  IconData? get icon => Icons.bluetooth;

  @override
  bool get isKnownDevice => !bluetoothDeviceDetails.isUnknown;
}

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class SMBusDeviceData extends DeviceData with _$SMBusDeviceData {
  @override
  final SMBusDeviceDetails smBusDeviceDetails;

  SMBusDeviceData({
    required this.smBusDeviceDetails,
    super.offsetX,
    super.offsetY,
    super.connected,
  });

  factory SMBusDeviceData.fromJson(Map<String, Object?> json) => _$SMBusDeviceDataFromJson(json);

  factory SMBusDeviceData.empty() =>
      SMBusDeviceData(smBusDeviceDetails: SMBusDeviceDetails.unknownSMBusDeviceDetails());

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
