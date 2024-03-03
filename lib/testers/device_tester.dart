import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';

abstract class DeviceTester {
  DevicesBloc devicesBloc = GetIt.instance.get();

  void test();

  void blink();

  void dispose();
}
