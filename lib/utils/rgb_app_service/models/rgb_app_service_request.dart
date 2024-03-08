import 'package:freezed_annotation/freezed_annotation.dart';

part '../../../generated/utils/rgb_app_service/models/rgb_app_service_request.freezed.dart';
part '../../../generated/utils/rgb_app_service/models/rgb_app_service_request.g.dart';

@freezed
class RgbAppServiceRequest with _$RgbAppServiceRequest {
  const factory RgbAppServiceRequest({
    required String command,
    Map<String, Object?>? data,
  }) = _RgbAppServiceRequest;

  factory RgbAppServiceRequest.fromJson(Map<String, Object?> json) => _$RgbAppServiceRequestFromJson(json);
}
