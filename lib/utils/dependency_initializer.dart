import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/key_bloc/key_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/services/loading_service.dart';
import 'package:rgb_app/utils/rgb_app_service/rgb_app_service.dart';
import 'package:rgb_app/utils/tick_provider.dart';

class DependencyInitializer {
  static final GetIt instance = GetIt.instance;

  static Future<void> init() async {
    _initLoadingService();
    await _initRgbAppService();
    _initTickProvider();
    await _initDevicesBloc();
    _initKeyBloc();
    _initEffectBloc();
    _initEffectsColorsCubit();
  }

  static void _initLoadingService() {
    final LoadingService loadingService = LoadingService();
    instance.registerSingleton(loadingService);
  }

  static Future<void> _initRgbAppService() async {
    final RgbAppService webSocketService = RgbAppService();
    await webSocketService.init();
    instance.registerSingleton(webSocketService);
  }

  static void _initTickProvider() {
    final TickProvider tickProvider = TickProvider();
    instance.registerSingleton(tickProvider);
  }

  static Future<void> _initDevicesBloc() async {
    final DevicesBloc devicesBloc = DevicesBloc(tickProvider: instance.get());
    await devicesBloc.init();
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

  static void _initEffectBloc() async {
    final EffectBloc effectBloc = EffectBloc(tickProvider: instance.get());
    instance.registerSingleton(effectBloc);
  }

  static void _initEffectsColorsCubit() async {
    final EffectsColorsCubit effectsColorsCubit = EffectsColorsCubit();
    instance.registerSingleton(effectsColorsCubit);
  }
}
