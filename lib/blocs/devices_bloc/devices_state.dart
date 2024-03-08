import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/json_converters/unique_key_converter.dart';
import 'package:rgb_app/models/device_data.dart';

part '../../generated/blocs/devices_bloc/devices_state.freezed.dart';
part '../../generated/blocs/devices_bloc/devices_state.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class DevicesState with _$DevicesState {
  factory DevicesState({
    required List<DeviceData> devicesData,
    @UniqueKeyConverter() required UniqueKey key,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    @Default(<DeviceData>[])
    List<DeviceData> availableDevices,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    @Default(<DeviceInterface>[])
    List<DeviceInterface> deviceInstances,
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    @Default(<DeviceData>[])
    List<DeviceData> connectedDevices,
  }) = _DevicesState;

  factory DevicesState.empty() => DevicesState(
        devicesData: <DeviceData>[],
        deviceInstances: <DeviceInterface>[],
        availableDevices: <DeviceData>[],
        connectedDevices: <DeviceData>[],
        key: UniqueKey(),
      );

  factory DevicesState.fromJson(Map<String, Object?> json) => _$DevicesStateFromJson(json);

  factory DevicesState.fromJsonWithModifiableLists(Map<String, Object?> json) {
    final DevicesState state = DevicesState.fromJson(json);
    return DevicesState(
      devicesData: <DeviceData>[...state.devicesData],
      deviceInstances: <DeviceInterface>[...state.deviceInstances],
      availableDevices: <DeviceData>[...state.availableDevices],
      connectedDevices: <DeviceData>[...state.connectedDevices],
      key: UniqueKey(),
    );
  }
}
