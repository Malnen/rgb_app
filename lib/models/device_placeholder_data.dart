import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math.dart';

part '../generated/models/device_placeholder_data.freezed.dart';

@freezed
class DevicePlaceholderData with _$DevicePlaceholderData {
  @override
  final Vector3 size;
  @override
  final Vector3 offset;

  DevicePlaceholderData({required this.size, required this.offset});
}
