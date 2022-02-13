import 'package:equatable/equatable.dart';

abstract class DeviceState extends Equatable {}

class DeviceInitialState extends DeviceState {
  @override
  List<Object> get props => <Object>[];
}

class DeviceInitializingState extends DeviceState {
  @override
  List<Object> get props => <Object>[];
}

class DeviceInitializedState extends DeviceState {
  @override
  List<Object> get props => <Object>[];
}
