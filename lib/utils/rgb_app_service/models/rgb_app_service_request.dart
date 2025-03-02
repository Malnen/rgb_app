import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/utils/rgb_app_service/models/rgb_app_service_request.freezed.dart';
part '../../../generated/utils/rgb_app_service/models/rgb_app_service_request.g.dart';

@Freezed(makeCollectionsUnmodifiable: false)
@JsonSerializable()
class RgbAppServiceRequest with _$RgbAppServiceRequest {
  @override
  final String command;
  @override
  final Map<String, Object?>? data;

  RgbAppServiceRequest({
    required this.command,
    required this.data,
  });

  factory RgbAppServiceRequest.fromJson(Map<String, Object?> json) => _$RgbAppServiceRequestFromJson(json);

  Map<String, Object?> toJson() => _$RgbAppServiceRequestToJson(this);
}
