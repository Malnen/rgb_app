import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_state.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_event.dart';
import 'package:rgb_app/devices/device_interface.dart';
import 'package:rgb_app/devices/keyboard_interface.dart';
import 'package:collection/collection.dart';

class DependencyInitializer {
  static final GetIt instance = GetIt.instance;

  static void init() {
    _initDevicesBloc();
    _initKeyBloc();
    _initEffectBloc();
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

    final DevicesBloc devicesBloc = GetIt.instance.get();
    final DevicesState state = devicesBloc.state;
    final List<DeviceInterface> deviceInstances = state.deviceInstances;
    final DeviceInterface? firstKeyboard =
        deviceInstances.firstWhereOrNull((final DeviceInterface element) => element is KeyboardInterface);
    final SetOffsetEvent setOffsetEvent = SetOffsetEvent(
      offsetX: firstKeyboard?.offsetX ?? 0,
      offsetY: firstKeyboard?.offsetY ?? 0,
    );
    keyBloc.add(setOffsetEvent);
  }

  static void _initEffectBloc() async {
    final EffectBloc effectBloc = EffectBloc();
    instance.registerSingleton(effectBloc);
    effectBloc.setBlocInExistingEffects();
  }
}
