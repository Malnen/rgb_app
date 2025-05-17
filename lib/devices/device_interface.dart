import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/devices/aura_led_controller/aura_led_controller.dart';
import 'package:rgb_app/devices/corsair_k_70/corsair_k_70.dart';
import 'package:rgb_app/devices/corsair_virtuoso/corsair_virtuoso.dart';
import 'package:rgb_app/devices/smbus/kingston/kingston_fury_ram.dart';
import 'package:rgb_app/devices/steel_series_rival_100/steel_series_rival_100.dart';
import 'package:rgb_app/devices/steel_series_rival_3/steel_series_rival_3.dart';
import 'package:rgb_app/devices/udp_network_device_interface.dart';
import 'package:rgb_app/devices/unknown_device.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/device_product_vendor.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/utils/smbus/smbus.dart';
import 'package:rxdart/rxdart.dart';

abstract class DeviceInterface {
  late EffectBloc effectBloc;
  late DevicesBloc devicesBloc;
  late EffectsColorsCubit effectsColorsCubit;
  late ValueNotifier<DeviceData> deviceDataNotifier;
  late BehaviorSubject<bool> isOpen;

  DeviceData get deviceData => deviceDataNotifier.value;

  set deviceData(DeviceData deviceData) => deviceDataNotifier.value = deviceData;

  int get offsetX => deviceData.offsetX;

  int get offsetY => deviceData.offsetY;

  List<Property<Object>> get properties => <Property<Object>>[];

  DeviceInterface({required DeviceData deviceData}) : deviceDataNotifier = ValueNotifier<DeviceData>(deviceData) {
    effectBloc = GetIt.instance.get();
    devicesBloc = GetIt.instance.get();
    effectsColorsCubit = GetIt.instance.get();
    isOpen = BehaviorSubject<bool>();
  }

  static DeviceInterface fromDeviceData({required DeviceData deviceData, required Smbus smbus}) {
    if (deviceData is UsbDeviceData) {
      return switch (deviceData.deviceProductVendor.productVendor) {
        DeviceProductVendor.corsairK70 => CorsairK70(deviceData: deviceData),
        DeviceProductVendor.corsairVirtuoso => CorsairVirtuoso(deviceData: deviceData),
        DeviceProductVendor.steelSeriesRival100 => SteelSeriesRival100(deviceData: deviceData),
        DeviceProductVendor.steelSeriesRival3 => SteelSeriesRival3(deviceData: deviceData),
        DeviceProductVendor.auraLEDController => AuraLEDController(deviceData: deviceData),
        _ => UnknownDevice(deviceData: deviceData),
      };
    } else if (deviceData is SMBusDeviceData) {
      if (deviceData.name == KingstonFuryRam.name) {
        return KingstonFuryRam(deviceData: deviceData, smbus: smbus);
      }
    } else if (deviceData is UdpNetworkDeviceData) {
      return UdpNetworkDeviceInterface(deviceData: deviceData);
    }

    throw Error();
  }

  @mustCallSuper
  Future<void> init() async {
    for (Property<Object> property in properties) {
      property.addListener(onPropertyChanged);
      property.notify();
    }
  }

  Future<void> dispose() async {
    await isOpen.close();
  }

  void test();

  void update() {}

  void blink();

  material.Size getSize();

  void updatePropertiesDeviceData() {
    for (Property<Object> property in properties) {
      final String idn = property.idn;
      final Property<Object>? deviceDataProperty = deviceData.properties.firstWhereOrNull(
        (Property<Object> deviceDataProperty) => idn == deviceDataProperty.idn,
      );
      if (deviceDataProperty != null) {
        property.updateProperty(deviceDataProperty);
      }
    }
  }

  @protected
  void onPropertyChanged() {
    final DeviceData updatedDeviceData = deviceData.copyWith(
      properties: properties,
      key: UniqueKey(),
    );
    final UpdateDeviceDataEvent event = UpdateDeviceDataEvent(deviceData: updatedDeviceData);
    devicesBloc.add(event);
  }
}
