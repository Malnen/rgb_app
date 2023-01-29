import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/utils/hot_plug/usb_hot_plug_handler.dart';

class DependencyInitializer {
  static final GetIt instance = GetIt.instance;

  static void init() {
    _initDevicesBloc();
    _initKeyBloc();
    _initEffectBlocAndInitEffects();
    _initUsbHotPlugHandler();
  }

  static void _initDevicesBloc() {
    final DevicesBloc devicesBloc = DevicesBloc();
    instance.registerSingleton(devicesBloc);

    final LoadAvailableDevicesEvent loadAvailableDevicesEvent = LoadAvailableDevicesEvent();
    devicesBloc.add(loadAvailableDevicesEvent);

    final RestoreDevicesEvent restoreDevicesEvent = RestoreDevicesEvent();
    devicesBloc.add(restoreDevicesEvent);
  }

  static void _initKeyBloc() {
    final KeyBloc keyBloc = KeyBloc();
    instance.registerSingleton(keyBloc);
  }

  static void _initEffectBlocAndInitEffects() async {
    final EffectBloc effectBloc = EffectBloc();
    instance.registerSingleton(effectBloc);
    effectBloc.setBlocInExistingEffectsAndInit();
  }

  static void _initUsbHotPlugHandler() {
    UsbHotPlugHandler.tryListen();
  }
}
