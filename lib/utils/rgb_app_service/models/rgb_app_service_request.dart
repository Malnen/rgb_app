import 'package:equatable/equatable.dart';

class RgbAppServiceRequest extends Equatable {
  final String command;
  final Map<String, Object>? data;

  RgbAppServiceRequest({required this.command, this.data});

  @override
  List<Object> get props => <Object>[];

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'command': command,
      'data': data,
    };
  }
}
