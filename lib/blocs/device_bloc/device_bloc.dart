import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rgb_app/blocs/device_bloc/device_event.dart';

import '../../devices/device.dart';
import 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, DeviceState> {
  final Device device;

  DeviceBloc({required this.device}) : super(DeviceInitialState());
}
