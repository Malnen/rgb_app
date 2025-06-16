import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_bloc.dart';
import 'package:rgb_app/blocs/devices_bloc/devices_event.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_bloc.dart';
import 'package:rgb_app/blocs/effects_bloc/effect_state.dart';
import 'package:rgb_app/cubits/effects_colors_cubit/effects_colors_cubit.dart';
import 'package:rgb_app/devices/aura_led_controller/aura_led_controller.dart';
import 'package:rgb_app/devices/corsair_icue_link_hub/corsair_icue_link_hub.dart';
import 'package:rgb_app/devices/corsair_keyboard/corsair_keyboard.dart';
import 'package:rgb_app/devices/corsair_virtuoso/corsair_virtuoso.dart';
import 'package:rgb_app/devices/smbus/kingston/kingston_fury_ram.dart';
import 'package:rgb_app/devices/steel_series_rival_100/steel_series_rival_100.dart';
import 'package:rgb_app/devices/steel_series_rival_3/steel_series_rival_3.dart';
import 'package:rgb_app/devices/udp_network_device_interface.dart';
import 'package:rgb_app/devices/unknown_device.dart';
import 'package:rgb_app/extensions/vector_3_extension.dart';
import 'package:rgb_app/mixins/subscriber.dart';
import 'package:rgb_app/models/device_data.dart';
import 'package:rgb_app/models/device_product_vendor.dart';
import 'package:rgb_app/models/numeric_property.dart';
import 'package:rgb_app/models/property.dart';
import 'package:rgb_app/utils/smbus/smbus.dart';
import 'package:rgb_app/utils/usb_device_data_sender/usb_device_data_sender.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vector_math/vector_math.dart';

abstract class DeviceInterface with Subscriber {
  @protected
  late EffectBloc effectBloc;
  @protected
  late DevicesBloc devicesBloc;
  @protected
  late EffectsColorsCubit effectsColorsCubit;
  late ValueNotifier<DeviceData> deviceDataNotifier;
  late BehaviorSubject<bool> isOpen;
  @protected
  late NumericProperty offsetXProperty;
  @protected
  late NumericProperty offsetYProperty;
  @protected
  late NumericProperty offsetZProperty;
  @protected
  late NumericProperty scaleXProperty;
  @protected
  late NumericProperty scaleYProperty;
  @protected
  late NumericProperty scaleZProperty;
  @protected
  late NumericProperty rotationXProperty;
  @protected
  late NumericProperty rotationYProperty;
  @protected
  late NumericProperty rotationZProperty;

  DeviceData get deviceData => deviceDataNotifier.value;

  set deviceData(DeviceData deviceData) => deviceDataNotifier.value = deviceData;

  int get offsetX => deviceData.offset.x.toInt();

  int get offsetY => deviceData.offset.y.toInt();

  int get offsetZ => deviceData.offset.z.toInt();

  Vector3 get scale => deviceData.scale;

  Vector3 get rotation => deviceData.rotation;

  List<Property<Object>> get properties => <Property<Object>>[
        offsetXProperty,
        offsetYProperty,
        offsetZProperty,
        scaleXProperty,
        scaleYProperty,
        scaleZProperty,
        rotationXProperty,
        rotationYProperty,
        rotationZProperty,
      ];

  DeviceInterface({required DeviceData deviceData})
      : deviceDataNotifier = ValueNotifier<DeviceData>(deviceData),
        offsetXProperty = NumericProperty(
          initialValue: 0,
          name: 'Offset X',
          idn: 'offsetX',
          min: 0,
          max: 100,
          precision: 0,
        ),
        offsetYProperty = NumericProperty(
          initialValue: 0,
          name: 'Offset Y',
          idn: 'offsetY',
          min: 0,
          max: 100,
          precision: 0,
        ),
        offsetZProperty = NumericProperty(
          initialValue: 0,
          name: 'Offset Z',
          idn: 'offsetZ',
          min: 0,
          max: 100,
          precision: 0,
        ),
        scaleXProperty = NumericProperty(
          initialValue: 1,
          name: 'Scale X',
          idn: 'scaleX',
          min: 0.01,
          max: 1,
          precision: 3,
        ),
        scaleYProperty = NumericProperty(
          initialValue: 1,
          name: 'Scale Y',
          idn: 'scaleY',
          min: 0.01,
          max: 1,
          precision: 3,
        ),
        scaleZProperty = NumericProperty(
          initialValue: 1,
          name: 'Scale Z',
          idn: 'scaleZ',
          min: 0.01,
          max: 1,
          precision: 3,
        ),
        rotationXProperty = NumericProperty(
          initialValue: 1,
          name: 'Rotation X',
          idn: 'scaleX',
          min: 0,
          max: 360,
          precision: 0,
        ),
        rotationYProperty = NumericProperty(
          initialValue: 1,
          name: 'Rotation Y',
          idn: 'rotationY',
          min: 0,
          max: 360,
          precision: 0,
        ),
        rotationZProperty = NumericProperty(
          initialValue: 1,
          name: 'Rotation Z',
          idn: 'rotationZ',
          min: 0,
          max: 360,
          precision: 0,
        ) {
    effectBloc = GetIt.instance.get();
    devicesBloc = GetIt.instance.get();
    effectsColorsCubit = GetIt.instance.get();
    isOpen = BehaviorSubject<bool>();
  }

  static DeviceInterface fromDeviceData({
    required DeviceData deviceData,
    required UsbDeviceDataSender usbDeviceDataSender,
    required Smbus smbus,
  }) {
    if (deviceData is UsbDeviceData) {
      return switch (deviceData.deviceProductVendor.productVendor) {
        DeviceProductVendor.corsairK70Lux =>
          CorsairKeyboard(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.corsairK70MKIILowProfile =>
          CorsairKeyboard(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.corsairK95Platinum =>
          CorsairKeyboard(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.corsairICueLinkHub =>
          CorsairICueLinkHub(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.corsairVirtuoso =>
          CorsairVirtuoso(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.steelSeriesRival100 =>
          SteelSeriesRival100(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.steelSeriesRival3 =>
          SteelSeriesRival3(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
        DeviceProductVendor.auraLEDController =>
          AuraLEDController(deviceData: deviceData, usbDeviceDataSender: usbDeviceDataSender),
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
    _updateOffsetProperties();
    _updateScaleProperties();
    _updateRotationProperties();
    for (Property<Object> property in properties) {
      property.addListener(onPropertyChanged);
      property.notify();
    }

    offsetXProperty.addValueChangeListener((double x) => _updateOffset(x: x));
    offsetYProperty.addValueChangeListener((double y) => _updateOffset(y: y));
    offsetZProperty.addValueChangeListener((double z) => _updateOffset(z: z));
    scaleXProperty.addValueChangeListener((double x) => _updateScale(x: x));
    scaleYProperty.addValueChangeListener((double y) => _updateScale(y: y));
    scaleZProperty.addValueChangeListener((double z) => _updateScale(z: z));
    rotationXProperty.addValueChangeListener((double x) => _updateRotation(x: x));
    rotationYProperty.addValueChangeListener((double y) => _updateRotation(y: y));
    rotationZProperty.addValueChangeListener((double z) => _updateRotation(z: z));
    subscribe(effectBloc.stream.listen(_setOffsetMax));
    _setOffsetMax(effectBloc.state);
  }

  Future<void> dispose() async {
    await isOpen.close();
    unsubscribe();
  }

  void test();

  void update() {}

  void blink();

  Vector3 getSize();

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

  @protected
  Color getColorAt({
    required int x,
    required int y,
    Vector3? offset,
    Vector3? scale,
    Vector3? rotation,
    Vector3? size,
  }) {
    scale ??= this.scale;
    offset ??= deviceData.offset;
    rotation ??= deviceData.rotation;
    size ??= getSize();

    final List<List<Color>> colors = effectsColorsCubit.colors;
    final int width = colors[0].length;
    final int height = colors.length;

    final double radiansZ = radians(rotation.z);

    final double cx = size.x / 2;
    final double cy = size.z / 2;

    final double dx = x - cx;
    final double dy = y - cy;

    final double rotatedX = dx * cos(radiansZ) - dy * sin(radiansZ);
    final double rotatedY = dx * sin(radiansZ) + dy * cos(radiansZ);

    final double finalX = rotatedX + cx;
    final double finalY = rotatedY + cy;

    final double fx = finalX * scale.x + offset.x;
    final double fz = finalY * scale.z + offset.z;

    final int x0 = fx.floor().clamp(0, width - 1);
    final int x1 = (x0 + 1).clamp(0, width - 1);
    final int z0 = fz.floor().clamp(0, height - 1);
    final int z1 = (z0 + 1).clamp(0, height - 1);

    final double tx = fx - fx.floor();
    final double tz = fz - fz.floor();

    final Color c00 = colors[z0][x0];
    final Color c10 = colors[z0][x1];
    final Color c01 = colors[z1][x0];
    final Color c11 = colors[z1][x1];

    final Color top = _lerp(c00, c10, tx);
    final Color bottom = _lerp(c01, c11, tx);

    return _lerp(top, bottom, tz);
  }

  void _setOffsetMax(EffectState state) {
    final Vector3 size = getSize();
    offsetXProperty.max = state.effectGridData.size.x - size.x;
    offsetYProperty.max = state.effectGridData.size.y - size.y;
    offsetZProperty.max = state.effectGridData.size.z - size.z;
  }

  void _updateOffsetProperties() {
    final Vector3 offset = deviceData.offset;
    if (offset.x != offsetXProperty.value) {
      offsetXProperty.value = offset.x;
    }

    if (offset.y != offsetYProperty.value) {
      offsetYProperty.value = offset.y;
    }

    if (offset.z != offsetZProperty.value) {
      offsetZProperty.value = offset.z;
    }
  }

  void _updateOffset({double? x, double? y, double? z}) {
    final Vector3 offset = deviceData.offset;
    if (offset.x != x || offset.y != y || offset.z != z) {
      final UpdateDeviceProperties updateDeviceProperties = UpdateDeviceProperties(
        offset: offset.copyWith(x: x, y: y, z: z),
        deviceInterface: this,
      );
      devicesBloc.add(updateDeviceProperties);
    }
  }

  void _updateScaleProperties() {
    final Vector3 scale = deviceData.scale;
    if (scale.x != scaleXProperty.value) {
      scaleXProperty.value = scale.x;
    }

    if (scale.y != scaleYProperty.value) {
      scaleYProperty.value = scale.y;
    }

    if (scale.z != scaleZProperty.value) {
      scaleZProperty.value = scale.z;
    }
  }

  void _updateScale({double? x, double? y, double? z}) {
    final Vector3 scale = deviceData.scale;
    if (scale.x != x || scale.y != y || scale.z != z) {
      final UpdateDeviceProperties updateDeviceProperties = UpdateDeviceProperties(
        scale: scale.copyWith(x: x, y: y, z: z),
        deviceInterface: this,
      );
      devicesBloc.add(updateDeviceProperties);
    }
  }

  void _updateRotationProperties() {
    final Vector3 rotation = deviceData.rotation;
    if (rotation.x != rotationXProperty.value) {
      rotationXProperty.value = rotation.x;
    }

    if (rotation.y != rotationYProperty.value) {
      rotationYProperty.value = rotation.y;
    }

    if (rotation.z != rotationZProperty.value) {
      rotationZProperty.value = rotation.z;
    }
  }

  void _updateRotation({double? x, double? y, double? z}) {
    final Vector3 rotation = deviceData.rotation;
    if (rotation.x != x || rotation.y != y || rotation.z != z) {
      final UpdateDeviceProperties updateDeviceProperties = UpdateDeviceProperties(
        rotation: rotation.copyWith(x: x, y: y, z: z),
        deviceInterface: this,
      );
      devicesBloc.add(updateDeviceProperties);
    }
  }

  Color _lerp(Color a, Color b, double t) => Color.lerp(a, b, t) ?? a;
}
