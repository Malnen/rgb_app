import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/json_converters/icon_data_converter.dart';
import 'package:win_ble/win_ble.dart';

part '../generated/models/bluetooth_device_details.freezed.dart';
part '../generated/models/bluetooth_device_details.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class BluetoothDeviceDetails with _$BluetoothDeviceDetails {
  static const String blunoClock = 'bluno clock';
  static const String bluno = 'bluno';

  @override
  final String name;
  @override
  final String deviceId;
  @override
  final String rawName;
  @override
  @IconDataConverter()
  final IconData icon;

  bool get isUnknown => name.isEmpty;

  BluetoothDeviceDetails({
    required this.name,
    required this.deviceId,
    required this.rawName,
    required this.icon,
  });

  factory BluetoothDeviceDetails.unknownBluetoothDeviceDetails() => BluetoothDeviceDetails(
        name: '',
        deviceId: '',
        rawName: '',
        icon: Icons.question_mark,
      );

  static BluetoothDeviceDetails getType(Map<String, Object?> json) {
    String name = json['name'] as String;
    final String deviceId = json['deviceId'] as String;
    final String rawName = json['rawName'] as String;
    name = name.toLowerCase();

    return switch (name) {
      blunoClock => BluetoothDeviceDetails(
          name: name,
          deviceId: deviceId,
          rawName: rawName,
          icon: Icons.usb,
        ),
      bluno => BluetoothDeviceDetails(
          name: name,
          deviceId: deviceId,
          rawName: rawName,
          icon: Icons.usb,
        ),
      _ => BluetoothDeviceDetails.unknownBluetoothDeviceDetails(),
    };
  }

  factory BluetoothDeviceDetails.fromJson(Map<String, Object?> json) => getType(json);

  factory BluetoothDeviceDetails.fromBleDevice(BleDevice device) => BluetoothDeviceDetails.fromJson(<String, Object?>{
        'name': device.name,
        'deviceId': device.address,
        'rawName': device.name,
      });

  Map<String, Object?> toJson() => _$BluetoothDeviceDetailsToJson(this);
}
