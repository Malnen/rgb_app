import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/json_converters/unique_key_converter.dart';
import 'package:rgb_app/models/device_data.dart';

part '../../generated/blocs/devices_bloc/devices_state.freezed.dart';
part '../../generated/blocs/devices_bloc/devices_state.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class DevicesState with _$DevicesState {
  @override
  final List<DeviceData> devicesData;

  @override
  @UniqueKeyConverter()
  final UniqueKey key;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<DeviceData> availableDevices;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<DeviceInterface> deviceInstances;

  DevicesState({
    required this.devicesData,
    required this.key,
    this.availableDevices = const <DeviceData>[],
    this.deviceInstances = const <DeviceInterface>[],
  });

  factory DevicesState.empty() => DevicesState(
        devicesData: <DeviceData>[],
        deviceInstances: <DeviceInterface>[],
        availableDevices: <DeviceData>[],
        key: UniqueKey(),
      );

  factory DevicesState.fromJson(Map<String, Object?> json) => _$DevicesStateFromJson(json);

  Map<String, Object?> toJson() => _$DevicesStateToJson(this);

  factory DevicesState.fromJsonWithModifiableLists(Map<String, Object?> json) {
    final DevicesState state = DevicesState.fromJson(json);
    return DevicesState(
      devicesData: <DeviceData>[...state.devicesData],
      deviceInstances: <DeviceInterface>[...state.deviceInstances],
      availableDevices: <DeviceData>[...state.availableDevices],
      key: UniqueKey(),
    );
  }
}
