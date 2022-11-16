import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';

class DependencyInitializer {
  static void init() {
    final GetIt instance = GetIt.instance;
    _initEffectBloc(instance);
    _initDevicesBloc(instance);
  }

  static void _initEffectBloc(GetIt instance) {
    EffectBloc effectBloc = EffectBloc();
    instance.registerSingleton(effectBloc);
  }

  static void _initDevicesBloc(GetIt instance) {
    DevicesBloc devicesBloc = DevicesBloc();
    instance.registerSingleton(devicesBloc);

    final LoadAvailableDevicesEvent loadAvailableDevicesEvent = LoadAvailableDevicesEvent();
    devicesBloc.add(loadAvailableDevicesEvent);

    final RestoreDevicesEvent restoreDevicesEvent = RestoreDevicesEvent();
    devicesBloc.add(restoreDevicesEvent);
  }
}
