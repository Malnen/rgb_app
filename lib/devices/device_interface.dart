import 'package:flutter/material.dart' as material;
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/devices/aura_led_controller/aura_led_controller.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k_70.dart';
import 'package:rgb_app/devices/corsair_virtuoso/corsair_virtuoso.dart';
import 'package:rgb_app/devices/steel_series_rival_100/steel_series_rival_100.dart';
import 'package:rgb_app/devices/steel_series_rival_3/steel_series_rival_3.dart';
import 'package:rgb_app/devices/unknown_device.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/device_product_vendor.dart';
import 'package:rxdart/rxdart.dart';

abstract class DeviceInterface {
  late EffectBloc effectBloc;
  late EffectsColorsCubit effectsColorsCubit;
  late DeviceData deviceData;
  late BehaviorSubject<bool> isOpen;
  late String guid;

  int get offsetX => deviceData.offsetX;

  int get offsetY => deviceData.offsetY;

  int get interface;

  int get configuration;

  DeviceInterface({required this.deviceData}) {
    effectBloc = GetIt.instance.get();
    effectsColorsCubit = GetIt.instance.get();
    isOpen = BehaviorSubject<bool>();
  }

  static DeviceInterface fromDeviceData({required DeviceData deviceData}) =>
      switch (deviceData.deviceProductVendor.productVendor) {
        DeviceProductVendor.corsairK70 => CorsairK70(deviceData: deviceData),
        DeviceProductVendor.corsairVirtuoso => CorsairVirtuoso(deviceData: deviceData),
        DeviceProductVendor.steelSeriesRival100 => SteelSeriesRival100(deviceData: deviceData),
        DeviceProductVendor.steelSeriesRival3 => SteelSeriesRival3(deviceData: deviceData),
        DeviceProductVendor.auraLEDController => AuraLEDController(deviceData: deviceData),
        _ => UnknownDevice(deviceData: deviceData),
      } as DeviceInterface;

  List<List<int>> getPackets();

  Map<String, Object> getDataToSend();

  void init() {}

  void dispose() {
    isOpen.close();
  }

  void test();

  void update() {}

  void blink();

  material.Size getSize();
}
