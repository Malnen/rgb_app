import 'package:equatable/equatable.dart';
import 'package:rgb_app/interfaces/serializable.dart';

class RgbAppServiceRequest extends Equatable implements Serializable {
  final String command;

  RgbAppServiceRequest(this.command);

  @override
  List<Object> get props => <Object>[];

  @override
  Map<String, Object> toJson() {
    return <String, Object>{
      'command': command,
    };
  }
}
